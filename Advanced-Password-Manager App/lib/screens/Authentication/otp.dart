import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/components/buttons.dart';
import 'package:safe_pass_sheild/models/user.model.dart';
import 'package:safe_pass_sheild/screens/Authentication/pinCode.dart';
import 'package:safe_pass_sheild/utilities/otp_utility.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var otp;

  UserModel user = UserModel(email: '', password: '');

  @override
  void initState() {
    super.initState();

    getUser();
  }

  void getUser() async {
    user = (await UserModel.GetUserFromSharedPrefs())!;

    GenerateOTP();
  }

  void GenerateOTP() {
    setState(() {
      otp = OTPUtility.GenerateOTP(user.email);
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool validateOtp(String code) {
    if (code == otp) {
      return true;
    } else {
      return false;
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              leading: const BackButton(color: Colors.black),
            ),
            body: Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 10),
              child: Column(
                children: [
                  const Row(
                    children: [
                      SizedBox(
                        width: 280,
                        child: Text(
                          "OTP code verification",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // SizedBox(width: 10),
                      Icon(
                        Icons.key_sharp,
                        color: Colors.deepPurple,
                        size: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        "${"We have sent you OTP on your email " + user.email}. Please enter code below to verify",
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
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
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
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        GenerateOTP();
                      },
                      child: const Text("Resend New OTP"),
                    ),
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
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          Map<String, String> pathParams = {
                                            'type': PinCodeScreenType.CreatePin
                                                .toShortString(),
                                          };
                                          context.pushNamed(
                                              MyScreens.pinCode.toShortString(),
                                              pathParameters: pathParams);
                                        } else {
                                          MyToast().showError("Invalid OTP");
                                        }
                                      },
                                    ),
                            ),
                          )))
                ],
              ),
            )));
  }
}
