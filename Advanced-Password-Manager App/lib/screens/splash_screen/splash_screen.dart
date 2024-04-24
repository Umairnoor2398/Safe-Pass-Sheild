import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_pass_sheild/Constants/my_constants.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 5), () {
      context.goNamed(MyScreens.home.toShortString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: MyConstants.appName.split(' ').length,
                itemBuilder: (context, index) {
                  return Text(
                    "\t" + MyConstants.appName.split(' ')[index],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: MyConstants.kTextBlackColor,
                          fontSize: 50.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                  );
                },
              ),
            ),
            Image.asset(
              MyConstants.logoPath,
              width: 150.0,
              height: 150.0,
            ),
            Container(
              height: 250.0,
            )
          ],
        ),
      ),
    );
  }
}
