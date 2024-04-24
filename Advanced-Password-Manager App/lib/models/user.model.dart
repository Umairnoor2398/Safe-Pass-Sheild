import 'dart:convert';

import 'package:safe_pass_sheild/models/pass_profiles.model.dart';
import 'package:safe_pass_sheild/services/shared_prefs.dart';

enum LoginType { email, google }

class UserModel {
  final String? username;
  final String email;
  final String password;

  final LoginType? loginType;


  late List<PasswordProfile> passwordProfile;

  UserModel({
    this.username,
    required this.email,
    required this.password,
    this.loginType,
  });

  void StoreUserToSharedPrefs() {
    // SharedPrefs.setString('username', username ?? '');
    // SharedPrefs.setString('email', email);
    // SharedPrefs.setString('password', password);
    // SharedPrefs.setString('loginType', loginType.toString());

    SharedPrefs.setString('user', toJson());
  }

  static Future<UserModel?> GetUserFromSharedPrefs() async {
    // final username = await SharedPrefs.getString('username');
    // final email = await SharedPrefs.getString('email');
    // final password = await SharedPrefs.getString('password');
    // final loginType = await SharedPrefs.getString('loginType');

    final user = await SharedPrefs.getString('user');

    if (user == "") {
      return null;
    }

    return UserModel.fromJson(user);
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? password,
    LoginType? loginType,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      loginType: loginType ?? this.loginType,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'username': username});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'loginType': loginType.toString()});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      loginType: map['loginType'] == 'LoginType.email'
          ? LoginType.email
          : LoginType.google,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(username: $username, email: $email, password: $password, loginType: $loginType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.username == username &&
        other.email == email &&
        other.password == password &&
        other.loginType == loginType;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        loginType.hashCode;
  }
}
