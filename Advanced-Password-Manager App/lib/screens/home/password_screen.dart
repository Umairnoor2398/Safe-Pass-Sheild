// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/components/appbar.dart';
import 'package:safe_pass_sheild/screens/home/create_password_screen.dart';
import 'package:safe_pass_sheild/utilities/loading_dialog_utility.dart';
import 'package:tuple/tuple.dart';

class PasswordScreen extends StatefulWidget {
  static List<Tuple2<String, Map<String, dynamic>>> passwords = [];
  static String username = '';
  static String salt = '';

  PasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  void initState() {
    super.initState();

    LoadData();
  }

  void LoadData() {
    dataLoaded = false;

    passTypes = PasswordScreen.passwords
        .map((record) => _normalizeWebsite(record.item2['username']))
        .toSet()
        .toList();

    filteredpassTypes = passTypes
        .where((element) => element
            .trim()
            .replaceAll(' ', '')
            .toLowerCase()
            .contains(search.text.trim().replaceAll(' ', '').toLowerCase()))
        .toList();

    dataLoaded = true;
    setState(() {});
  }

  bool dataLoaded = false;

  String _normalizeWebsite(String? website) {
    return website?.toLowerCase().replaceAll(' ', '') ?? '';
  }

  List<String> passTypes = [];
  List<String> filteredpassTypes = [];

  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return dataLoaded == false
        ? Container(child: LoadingDialog())
        : SafeArea(
            child: Scaffold(
              body: MainScreen(
                  username: PasswordScreen.username,
                  appBarSearchCallBack: (value) {
                    filteredpassTypes = passTypes
                        .where((element) => element
                            .trim()
                            .replaceAll(' ', '')
                            .toLowerCase()
                            .contains(search.text
                                .trim()
                                .replaceAll(' ', '')
                                .toLowerCase()))
                        .toList();

                    setState(() {});
                  },
                  searchController: search,
                  lst: filteredpassTypes,
                  SingleCardCallBack: (_id, _password) {
                    var website = PasswordScreen.passwords[0].item2['website'];
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CreatePasswordScreen(
                    //       username: PasswordScreen.username,
                    //       websites: [website],
                    //       passId: _id,
                    //       password: _password,
                    //     ),
                    //   ),
                    // );
                    CreatePasswordScreen.username = PasswordScreen.username;
                    CreatePasswordScreen.websites = [website];
                    CreatePasswordScreen.passId = _id;
                    CreatePasswordScreen.password = _password;
                    context.pushNamed(
                        MyScreens.createPasswordScreen.toShortString());
                  },
                  pass: PasswordScreen.passwords),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  var website = PasswordScreen.passwords[0].item2['website'];
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CreatePasswordScreen(
                  //       username: PasswordScreen.username,
                  //       websites: [website],
                  //     ),
                  //   ),
                  // );
                  CreatePasswordScreen.username = PasswordScreen.username;
                  CreatePasswordScreen.websites = [website];
                  context.pushNamed(
                      MyScreens.createPasswordScreen.toShortString());
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          );
  }

  Widget MainScreen(
      {required String username,
      required Function appBarSearchCallBack,
      required TextEditingController searchController,
      required List<String> lst,
      required Function SingleCardCallBack,
      required List<Tuple2<String, Map<String, dynamic>>> pass}) {
    var website = pass[0].item2['website'];
    return SingleChildScrollView(
      child: Column(
        children: [
          MyAppBar(
            username: username,
            onChanged: appBarSearchCallBack,
            search: searchController,
            salt: PasswordScreen.salt,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Passwords for $website',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: lst.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              String value = lst[index];
              var _value = pass[index];

              return GestureDetector(
                onTap: () {
                  SingleCardCallBack(_value.item1, _value.item2);
                  // GoToPasswordScreen(context, username, value, pass);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0.05,
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          backgroundColor: index % 2 == 0
                              ? Colors.deepPurpleAccent
                              : Colors.purple,
                          minRadius: 40,
                          foregroundColor: Colors.white,
                          child: Center(
                            child: Text(
                              value
                                  .toLowerCase()
                                  .replaceAll('https://', '')
                                  .replaceAll('http://', '')
                                  .toUpperCase()[0],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: Text(
                          value
                              .toLowerCase()
                              .replaceAll('https://', '')
                              .replaceAll('http://', ''),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Text('0 Passwords available'),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
