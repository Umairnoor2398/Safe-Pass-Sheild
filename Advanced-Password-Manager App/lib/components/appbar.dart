import 'package:flutter/material.dart';

import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import 'package:safe_pass_sheild/utilities/toast.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
    required this.onChanged,
    required this.search,
    required this.username,
    required this.salt,
    this.backIcon,
    this.DisplaySearchbar,
  }) : super(key: key);

  final Function onChanged;
  final TextEditingController search;
  final String username;

  final String salt;

  final IconData? backIcon;

  final bool? DisplaySearchbar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: DisplaySearchbar == false ? 120 : 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.deepPurple.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              backIcon == null
                  ? CircleButton(
                      icon: Icons.logout,
                      onPressed: () async {
                        await AccountController.signOut();
                      },
                    )
                  : CircleButton(
                      icon: Icons.arrow_back_ios_new_sharp,
                      onPressed: () async {
                        await AccountController.signOut();
                      },
                    ),
            ],
          ),
          DisplaySearchbar == false
              ? Container()
              : Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Click the icon to copy the salt and add to our chrome extension',
                        softWrap: true,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    CircleButton(
                      icon: Icons.copy,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: salt))
                            .then(
                                (value) => MyToast().showSuccess('Key Copied'))
                            .onError((error, stackTrace) =>
                                MyToast().showError("Cannot Copy Key"));
                      },
                    ),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          DisplaySearchbar == false
              ? Container()
              : SearchTextField(
                  onChanged: onChanged,
                  search: search,
                  hintText: 'Search',
                  icon: Icons.search,
                ),
        ],
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    required this.onChanged,
    required this.search,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  final Function onChanged;
  final TextEditingController search;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: search,
      onChanged: (value) {
        onChanged(value);
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(color: Colors.white),
        fillColor: Colors.white,
        isDense: true,
        prefixIcon: Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // sets border color to white when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // sets border color to white when focused
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  const CircleButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          // color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
