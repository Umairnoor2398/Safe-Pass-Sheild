import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/authenticator/components/home/home.dart';
import 'package:safe_pass_sheild/screens/Authentication/login.dart';
import 'package:safe_pass_sheild/screens/Authentication/otp.dart';
import 'package:safe_pass_sheild/screens/Authentication/pinCode.dart';
import 'package:safe_pass_sheild/screens/Authentication/reset_password.dart';
import 'package:safe_pass_sheild/screens/Authentication/signup.dart';
import 'package:safe_pass_sheild/screens/home/authenticator.dart';
import 'package:safe_pass_sheild/screens/home/create_password_screen.dart';
import 'package:safe_pass_sheild/screens/home/home_screen.dart';
import 'package:safe_pass_sheild/screens/home/password_screen.dart';
import 'package:safe_pass_sheild/screens/splash_screen/splash_screen.dart';

part 'package:safe_pass_sheild/utilities/enum_utilities.dart';

class MyRouter {
  static final GoRouter _loginrouter = GoRouter(
    initialLocation: '/Login',
    routes: [
      GoRoute(
        path: '/SplashScreen',
        name: 'SplashScreen',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/Signup',
        name: 'Signup',
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: '/Login',
        name: 'Login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/OTP',
        name: 'OTP',
        builder: (context, state) => OTPScreen(),
      ),
      GoRoute(
        path: '/resetPassword',
        name: 'resetPassword',
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/pinCode/:type',
        name: 'pinCode',
        builder: (context, state) {
          final type = state.pathParameters['type'];
          return PinCodeScreen(type: type ?? '');
        },
      ),
    ],
    // errorBuilder: (context, state) => const MyHomePage(title: 'Error Page'),
  );
  static final GoRouter _mainrouter = GoRouter(
    initialLocation: '/pinCode2',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/password',
        name: 'password',
        builder: (context, state) => PasswordScreen(),
      ),
      GoRoute(
        path: '/createPasswordScreen',
        name: 'createPasswordScreen',
        builder: (context, state) => CreatePasswordScreen(),
      ),
      GoRoute(
        path: '/authenticator',
        name: 'authenticator',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: '/pinCode/:type',
        name: 'pinCode',
        builder: (context, state) {
          final type = state.pathParameters['type'];
          return PinCodeScreen(
              type: type ?? PinCodeScreenType.AuthenticatePin.toShortString());
        },
      ),
      GoRoute(
        path: '/pinCode2',
        name: 'pinCode2',
        builder: (context, state) {
          return PinCodeScreen(
              type: PinCodeScreenType.AuthenticatePin.toShortString());
        },
      ),
    ],
    // errorBuilder: (context, state) => const HomeScreen(),
  );

  static GoRouter get LoginRouter => _loginrouter;
  static GoRouter get MainRouter => _mainrouter;
}

enum MyScreens {
  SplashScreen,
  Signup,
  Login,
  OTP,
  home,
  resetPassword,
  pinCode,
  password,
  createPasswordScreen,
  authenticator,
}



// context.go('/')
// context.goNamed('home')
// Pass param
// path: '/details/:name'
// builder: (context, state) {
// final name=state.pathParameters['name'];
//  return DetailsPage(name: name);
//}
// context.go('/details/John')
// context.goNamed('details', parameters: {'name': 'John'})
