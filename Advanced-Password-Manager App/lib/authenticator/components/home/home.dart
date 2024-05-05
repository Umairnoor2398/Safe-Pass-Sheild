import 'dart:async';
// import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:safe_pass_sheild/components/appbar.dart';
import 'package:safe_pass_sheild/components/bottomnavigationbar.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/controllers/firestore_controller.dart';
import 'package:safe_pass_sheild/screens/home/create_password_screen.dart';
import 'package:safe_pass_sheild/utilities/loading_dialog_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth.dart';
import '../home/addappmodal.dart';
import '../home/updateappmodal.dart';
import '../../application_model.dart';
import '../../storage_util.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Application> apps = [];
  Timer? updateCodeTimer;
  Map<String, dynamic> content = Storage.initData;
  String? token;

  refreshCodes(Timer timer) {
    for (var app in apps) {
      app.refreshCode();
    }
    setState(() {
      apps = apps;
    });
  }

  _loadAppsFromStorage() async {
    var content = await Storage.getContent();
    // print("[home.dart 1] loaded content");
    // print(content);

    // print("[home.dart 2] setting apps");
    if (content["apps"] is! List) {
      content["apps"] = [];
      await Storage.setContent(content);
    }
    var appsList = (content["apps"] as List<dynamic>);
    List<Application> apps = [];
    for (int i = 0; i < appsList.length; i++) {
      if (appsList[i] is! Map<String, dynamic>) {
        appsList.removeAt(i);
        content["apps"] = appsList;
        await Storage.setContent(content);
      } else {
        Map<String, dynamic> app = appsList[i];
        String? id = app["id"];
        String? name = app["name"];
        String? key = app["key"];
        if (id == null || name == null || key == null) {
          appsList.removeAt(i);
          content["apps"] = appsList;
          await Storage.setContent(content);
        } else {
          // print("[home.dart 3] adding application: Application(id: $id, name: $name, key: $key)");
          var application = Application(id, name, key);
          apps.add(application);
        }
      }
    }
    setState(() {
      this.apps = apps;
      this.content = content;
    });
  }

  _getAuthState() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    if (token != null) {
      setState(() {
        this.token = token;
      });
      if (apps.isEmpty) {
        // check cloud if there's a backup
        var content = await CloudStorage.getJson(token);
        // print("Content: $content");
        if (content != null) {
          // found backup, store this locally.
          await Storage.setContent(content);
          await _loadAppsFromStorage();
          setState(() {
            this.content = content;
          });
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    updateCodeTimer = Timer.periodic(const Duration(seconds: 5), refreshCodes);
    _loadAppsFromStorage();
    _getAuthState();

    GetUserData();

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  deactivate() {
    if (updateCodeTimer != null) updateCodeTimer!.cancel();
    super.deactivate();
  }

  _editApp(String id) {
    onAppUpdated(Application app) {
      setState(() {
        apps = apps.map((x) {
          if (x.id == app.id) {
            return app;
          } else {
            return x;
          }
        }).toList();
        content["apps"] = apps.map((app) => app.toMap()).toList();
        Storage.setContent(content).then((x) {
          if (token != null) CloudStorage.setJson(token!);
        });
      });
    }

    onAppDeleted(Application app) {
      deleteApp() {
        Navigator.of(context).pop();
        setState(() {
          apps.removeWhere((x) => x.id == app.id);
          apps = apps;
          content["apps"] = apps.map((app) => app.toMap()).toList();
          Storage.setContent(content).then((x) {
            if (token != null) CloudStorage.setJson(token!);
          });
        });
      }

      AlertDialog alert = AlertDialog(
          title: const Text("Are you sure?"),
          content: Text("Are you sure you want to delete ${app.name}?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel")),
            TextButton(
                onPressed: deleteApp,
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)))
          ]);

      showDialog(context: context, builder: (BuildContext context) => alert);
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => UpdateAppModal(
            app: apps.firstWhere((x) => x.id == id,
                orElse: () => Application(id, "", "")),
            onAppUpdated: onAppUpdated,
            onAppDeleted: onAppDeleted),
        isScrollControlled: true);
  }

  _addApp(Application app) {
    setState(() {
      apps.add(app);
      apps = apps;
      content["apps"] = apps.map((app) => app.toMap()).toList();
      Storage.setContent(content).then((x) {
        if (token != null) CloudStorage.setJson(token!);
      });
    });
  }

  _logout() async {
    // print(token);
    const baseUrl = String.fromEnvironment("API_URL",
            defaultValue: "http://localhost:5000") +
        "/auth";
    if (token == null) return;
    /*var res = */ await http.delete(Uri.parse('$baseUrl/logout'),
        headers: {"Authorization": "Bearer $token"});
    // print(res.body);
    // var data = json.decode(res.body);
    // print(data);
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    setState(() {
      token = null;
    });
  }

  bool dataLoaded = false;

  Map<String, dynamic> userData = {};

  String username = '';

  Future<void> GetUserData() async {
    var user = await AccountController.GetCurrentUser();

    userData = await FireStoreController.getSingleRecord('Users', user.email!);

    username = userData['username'];
  }

  @override
  Widget build(BuildContext context) {
    const padding = 12.0;

    return dataLoaded == false
        ? Container(
            child: LoadingDialog(),
            color: Colors.white,
          )
        : SafeArea(
            child: Scaffold(
              body: Column(children: [
                MyAppBar(
                  username: username,
                  onChanged: () {},
                  search: TextEditingController(),
                  DisplaySearchbar: false,
                  salt: '',
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Authenticar Apps',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(
                        padding, padding / 2, padding, padding / 2),
                    child: Text("Tap to copy, long-press to edit",
                        style: TextStyle(color: Colors.black54))),
                apps.isNotEmpty
                    ? Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(
                              padding, padding, padding, padding),
                          children: apps
                              .map(
                                (app) => Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors
                                            .grey, // Choose your border color
                                        width:
                                            1.0, // Adjust the width of the border
                                      ),
                                    ),
                                  ),
                                  child: app.display(context, onEdit: _editApp),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(padding * 2),
                        child: Text("You haven't added any applications.",
                            style: TextStyle(fontSize: 20.0)))
              ]),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) =>
                          AddAppModal(onAppAdded: _addApp),
                      isScrollControlled: true);
                },
                tooltip: "Add application",
              ),
              bottomNavigationBar: MyBottomNavBar(selectedIndex: 1),
            ),
          );
  }
}
