import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';

import 'package:safe_pass_sheild/components/appbar.dart';
import 'package:safe_pass_sheild/components/buttons.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/controllers/firestore_controller.dart';

class TextFormFieldModel {
  String? name;
  String? value;
  TextEditingController controller;
  TextEditingController nameController;

  TextFormFieldModel({
    this.name,
    this.value,
    required this.controller,
    required this.nameController,
  }) {
    controller = TextEditingController(text: value);
    nameController = TextEditingController(text: name);
  }
}

// ignore: must_be_immutable
class CreatePasswordScreen extends StatefulWidget {
  CreatePasswordScreen({Key? key}) : super(key: key);

  static List<String> websites = [];
  static String username = '';
  static String salt = '';

  static String? passId;

  static Map<String, dynamic>? password;

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController website = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextFormFieldModel> fields = [];

  @override
  void initState() {
    super.initState();

    prepareForEdit();
  }

  Future<void> prepareForEdit() async {
    if (CreatePasswordScreen.passId != null &&
        CreatePasswordScreen.passId != '') {
      // var userData = await getUserDetails();
      username.text = CreatePasswordScreen.password!['username'];
      password.text = CreatePasswordScreen.password!['password'];
      website.text = CreatePasswordScreen.password!['website'];

      if (CreatePasswordScreen.password!['additionalData'] != null) {
        CreatePasswordScreen.password!['additionalData'].forEach((key, value) {
          fields.add(TextFormFieldModel(
              name: key,
              value: value,
              controller: TextEditingController(),
              nameController: TextEditingController()));
        });
      }

      setState(() {});
    }
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    var user = await AccountController.GetCurrentUser();

    var userData =
        await FireStoreController.getSingleRecord('Users', user.email!);

    return userData;
  }

  void _addNewField() {
    setState(() {
      fields.add(TextFormFieldModel(
          name: '',
          value: '',
          controller: TextEditingController(),
          nameController: TextEditingController()));
    });
  }

  void _removeField(int index) {
    setState(() {
      fields.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyAppBar(
                username: CreatePasswordScreen.username,
                onChanged: () {},
                search: TextEditingController(),
                DisplaySearchbar: false,
                salt: CreatePasswordScreen.salt,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TypeAheadField<String>(
                  suggestionsCallback: (search) => CreatePasswordScreen.websites
                      .where((element) =>
                          element.toLowerCase().contains(search.toLowerCase()))
                      .toList(),
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      onSaved: (value) {
                        // FocusScope.of(context).nextFocus();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name of website or app';
                        }
                        return null;
                      },
                      controller: website,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Website/App',
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        fillColor: Colors.deepPurple,
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.apps_sharp,
                          color: Colors.deepPurple,
                          size: 26,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .deepPurple), // sets border color to deepPurple when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .deepPurple), // sets border color to deepPurple when focused
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, city) {
                    return ListTile(
                      title: Text(city),
                    );
                  },
                  onSelected: (suggestion) {
                    website.text = suggestion;

                    setState(() {});
                  },
                ),
              ),

              SearchTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  search: username,
                  hintText: 'Username',
                  icon: Icons.account_circle),
              SearchTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  search: password,
                  hintText: 'Password',
                  icon: Icons.password),
              // SearchTextField(
              //     onChanged: (value) {},
              //     search: website,
              //     hintText: 'Website/App',
              //     icon: Icons.apps_sharp),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _addNewField();
                    },
                    child: Text('Add New Field'),
                  ),
                ),
              ),

              Container(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: fields.length,
                        itemBuilder: (context, index) {
                          int idx = index + 1;
                          return Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: SearchTextField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter field name';
                                      }
                                      return null;
                                    },
                                    search: fields[index].nameController,
                                    hintText: 'Field Name $idx',
                                    icon: Icons.opacity),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: SearchTextField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter field value';
                                      }
                                      return null;
                                    },
                                    search: fields[index].controller,
                                    hintText: 'Value $idx',
                                    icon: Icons.opacity),
                              ),
                              IconButton(
                                onPressed: () {
                                  _removeField(index);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Flexible(
              //   child:
              // ),

              SizedBox(
                height: 10,
              ),

              // Spacer(),
              MyButton(
                text: 'Save',
                borderColor: Colors.deepPurple,
                callback: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // MyToast().showSuccess('message');
                    bool edit = false;
                    if (CreatePasswordScreen.password == null) {
                      CreatePasswordScreen.password = {};
                    } else {
                      edit = true;
                    }

                    var userData = await getUserDetails();

                    CreatePasswordScreen.password!['isActive'] = true;
                    CreatePasswordScreen.password!['password'] = password.text;
                    CreatePasswordScreen.password!['user'] = userData['email'];
                    CreatePasswordScreen.password!['username'] = username.text;
                    CreatePasswordScreen.password!['website'] = website.text;

                    CreatePasswordScreen.password!['additionalData'] = {};

                    for (var i = 0; i < fields.length; i++) {
                      CreatePasswordScreen.password!['additionalData']
                              [fields[i].nameController.text] =
                          fields[i].controller.text;
                    }

                    // print(CreatePasswordScreen.password);

                    bool Completed = false;

                    if (edit == false) {
                      Completed =
                          await FireStoreController.addSingleRecordWithUniqueId(
                              'Passwords', CreatePasswordScreen.password!);
                    } else {
                      Completed = await FireStoreController.updateSingleRecord(
                          'Passwords',
                          CreatePasswordScreen.passId!,
                          CreatePasswordScreen.password!);
                    }

                    if (Completed) {
                      fields = [];
                      website.text = '';
                      username.text = '';
                      password.text = '';

                      context.goNamed(MyScreens.home.toShortString());

                      // Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  SearchTextField({
    Key? key,
    required this.validator,
    required this.search,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  final Function validator;
  final TextEditingController search;
  final String hintText;
  final IconData icon;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.search,
        validator: (value) {
          return widget.validator(value);
        },
        obscureText: widget.hintText == 'Password' ? !isVisible : false,
        style: TextStyle(color: Colors.deepPurple),
        decoration: InputDecoration(
          labelText: widget.hintText,
          // floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: Colors.deepPurple),
          fillColor: Colors.deepPurple,
          isDense: true,
          suffixIcon: widget.hintText == 'Password'
              ? IconButton(
                  onPressed: () {
                    //In here we will create a click to show and hide the password a toggle button
                    setState(() {
                      //toggle button
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    size: 25,
                  ),
                )
              : null,
          prefixIcon: widget.icon == Icons.opacity
              ? null
              : Icon(
                  widget.icon,
                  color: Colors.deepPurple,
                  size: 26,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .deepPurple), // sets border color to deepPurple when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .deepPurple), // sets border color to deepPurple when focused
          ),
        ),
      ),
    );
  }
}
