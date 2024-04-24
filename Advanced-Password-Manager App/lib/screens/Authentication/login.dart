import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_constants.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/components/buttons.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/models/user.model.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //We need two text editing controller

  //TextEditing controller to control the text when we enter into it
  final email = TextEditingController();
  final password = TextEditingController();

  //A bool variable for show and hide password
  bool isVisible = false;

  //Here is our bool variable
  bool isLoginTrue = false;

  //Now we should call this function in login button
  login() async {
    UserModel user = UserModel(
      email: email.text,
      password: password.text,
    );

    var _userCred = await AccountController.login(user, NeedsToast: true);

    if (_userCred != null) {
      MyToast().showSuccess("User Logged In Successfully");
    }
  }

  bool loading = false;

  //We have to create global key for our form
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //We put all our textfield to a form to be controlled and not allow as empty
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  //email field

                  //Before we show the image, after we copied the image we need to define the location in pubspec.yaml
                  Image.asset(
                    MyConstants.logoPath,
                    width: 210,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "email is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "email",
                      ),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
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

                  //Login button

                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            context.pushNamed(
                                MyScreens.resetPassword.toShortString());
                          },
                          child: const Text("Forgot Password?"))),
                  const SizedBox(height: 10),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : MyButton(
                          text: "LOGIN",
                          borderColor: Colors.deepPurple,
                          callback: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              //Login method will be here
                              login();
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                        ),
                  Container(
                    height: 10,
                  ),

                  // Google Sign in button Start
                  // loading
                  //     ? const Center(child: CircularProgressIndicator())
                  //     : SignInButton(Buttons.Google,
                  //         text: 'Continue With Google', onPressed: () async {
                  //         setState(() {
                  //           loading = true;
                  //         });
                  //         UserModel _user = UserModel(
                  //             email: '',
                  //             password: 'google',
                  //             loginType: LoginType.google,
                  //             username: '');

                  //         _user.StoreUserToSharedPrefs();
                  //         // googleLogin();
                  //         Map<String, String> pathParams = {
                  //           'type': PinCodeScreenType.CreatePin.toShortString(),
                  //         };
                  //         context.pushNamed(MyScreens.pinCode.toShortString(),
                  //             pathParameters: pathParams);
                  //         setState(() {
                  //           loading = false;
                  //         });
                  //       }),

                  // Google Sign in button End

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            context.pushNamed(MyScreens.Signup.toShortString());
                          },
                          child: const Text("SIGN UP"))
                    ],
                  ),

                  // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
                  isLoginTrue
                      ? const Text(
                          "email or passowrd is incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
