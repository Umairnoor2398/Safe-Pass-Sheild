// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/components/appbar.dart';
import 'package:safe_pass_sheild/components/bottomnavigationbar.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/controllers/firestore_controller.dart';
import 'package:safe_pass_sheild/screens/home/create_password_screen.dart';
import 'package:safe_pass_sheild/screens/home/password_screen.dart';
import 'package:safe_pass_sheild/utilities/loading_dialog_utility.dart';
import 'package:tuple/tuple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    search.text = '';

    dataLoaded = false;
    GetUserData();
  }

  bool dataLoaded = false;

  Map<String, dynamic> userData = {};

  List<Tuple2<String, Map<String, dynamic>>> passwords = [];

  String username = '';
  String salt = '';

  List<String> passTypes = [];
  List<String> filteredpassTypes = [];

  Future<void> GetUserData() async {
    var user = await AccountController.GetCurrentUser();

    userData = await FireStoreController.getSingleRecord('Users', user.email!);

    username = userData['username'];
    salt = userData['salt'];

    passwords =
        await FireStoreController.getListofRecords('Passwords', user.email!);

    passTypes = passwords
        .map((record) => _normalizeWebsite(record.item2['website']))
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

  String _normalizeWebsite(String? website) {
    return website?.toLowerCase().replaceAll(' ', '') ?? '';
  }

  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return dataLoaded == false
        ? Container(
            child: LoadingDialog(),
            color: Colors.white,
          )
        : SafeArea(
            child: Scaffold(
              body: MainScreen(
                  username: username,
                  appBarSearchCallBack: (value) {
                    filteredpassTypes = passTypes
                        .where((element) => element.contains(search.text))
                        .toList();

                    setState(() {});
                  },
                  searchController: search,
                  lst: filteredpassTypes,
                  SingleCardCallBack: () {},
                  pass: passwords),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CreatePasswordScreen(
                  //       username: username,
                  //       websites: passTypes,
                  //     ),
                  //   ),
                  // );
                  CreatePasswordScreen.username = username;
                  CreatePasswordScreen.websites = passTypes;
                  CreatePasswordScreen.salt = salt;
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
              bottomNavigationBar: MyBottomNavBar(selectedIndex: 0),
            ),
          );
  }

  void GoToPasswordScreen(BuildContext context, String username, String value,
      List<Tuple2<String, Map<String, dynamic>>> pass) {
    var _pass = pass.where((element) {
      return element.item2['website']
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .contains(value.trim().replaceAll(' ', '').toLowerCase());
    }).toList();

    PasswordScreen.username = username;
    PasswordScreen.passwords = _pass;

    context.pushNamed(MyScreens.password.toShortString());

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         PasswordScreen(username: username, passwords: pass),
    //   ),
    // );
  }

  Widget MainScreen(
      {required String username,
      required Function appBarSearchCallBack,
      required TextEditingController searchController,
      required List<String> lst,
      required VoidCallback SingleCardCallBack,
      required List<Tuple2<String, Map<String, dynamic>>> pass}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MyAppBar(
            username: username,
            onChanged: appBarSearchCallBack,
            search: searchController,
            salt: salt,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Passwords Profiles',
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

              return GestureDetector(
                onTap: () {
                  GoToPasswordScreen(context, username, value, pass);
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
                        child: Flexible(
                          child: Text(
                            value
                                .toLowerCase()
                                .replaceAll('https://', '')
                                .replaceAll('http://', ''),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
