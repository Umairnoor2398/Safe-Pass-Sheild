import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/components/buttons.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/utilities/otp_utility.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';
import 'package:safe_pass_sheild/utilities/validation_utility.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final email = TextEditingController();
  final otp = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = false;

  bool isEmailVerified = false;

  var otpCode = '';
  Future<void> GenerateOTP() async {
    setState(() {
      otpCode = '';
      isEmailVerified = false;
    });

    bool IsEmailExists = await AccountController.checkUserAccount(email.text);

    if (IsEmailExists) {
      otpCode = OTPUtility.GenerateOTP(email.text);
    }
  }

  bool validateOtp(String code) {
    setState(() {
      if (code == otpCode) {
        isEmailVerified = true;
      } else {
        isEmailVerified = false;
      }
    });

    return isEmailVerified;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // This makes the bottom sheet not dismissible
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 7,
              right: 7),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: otp,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please Enter a OTP Code";
                      }
                      if (value != null) {
                        var v = value;
                        if (!validateOtp(v)) {
                          return "Incorrect OTP";
                        }
                      }

                      return null;
                    },
                    onSaved: (value) {},
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        hintText: "Enter OTP",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Verify OTP",
                    borderColor: Colors.deepPurple,
                    callback: () {
                      if (validateOtp(otp.text)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SingleChildScrollView to have an scrol in the screen
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //We will copy the previous textfield we designed to avoid time consuming

                  const ListTile(
                    title: Text(
                      "Reset your Password",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),

                  //As we assigned our controller to the textformfields

                  Container(
                    margin: EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      enabled: !isEmailVerified,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Send OTP to email',
                        suffixIcon: TextButton(
                          onPressed: () async {
                            if (isEmailVerified) return;
                            await GenerateOTP();
                            if (otpCode != '') {
                              MyToast().showInfo("OTP sent to your email");

                              _showBottomSheet(context);
                            } else {
                              MyToast().showError(
                                  "No Account found with this email");
                            }
                            // Your action here
                          },
                          child: Text(
                            'Send OTP',
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "email is required";
                        }
                        if (ValidationUtility.isValidEmail(value) == false) {
                          return "Invalid Email";
                        }
                        return null;
                      },
                    ),
                  ),

                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: password,
                      enabled: isEmailVerified,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
                        }

                        if (ValidationUtility.isPasswordStrong(value) ==
                            false) {
                          MyToast().showInfo(
                              "Password must be 6 characters long, contain at least 1 uppercase letter, 1 lowercase letter, 1 digit and 1 special character");
                          return "Password is weak";
                        }

                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                //In here we will create a click to show and hide the password a toggle button
                                setState(() {
                                  //toggle button
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),

                  //Confirm Password field
                  // Now we check whether password matches or not
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: confirmPassword,
                      enabled: isEmailVerified,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "confirm password is required";
                        } else if (password.text != confirmPassword.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            //In here we will create a click to show and hide the password a toggle button
                            setState(() {
                              //toggle button
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  isEmailVerified
                      ? MyButton(
                          text: "Reset Password",
                          borderColor: Colors.deepPurple,
                          callback: () async {
                            if (formKey.currentState!.validate()) {
                              await AccountController.resetPassword(
                                  email.text, password.text);
                            }
                          },
                        )
                      : const Text(
                          "Please verify your email to continue",
                          style: TextStyle(color: Colors.red),
                        ),

                  //Login button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.goNamed(MyScreens.Login.toShortString());
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
