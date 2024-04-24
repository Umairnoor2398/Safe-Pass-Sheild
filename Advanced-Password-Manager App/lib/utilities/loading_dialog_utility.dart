import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 context = context;
//                 return const Loading();
//               },
//             );

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigator.pop(context);
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: SpinKitCubeGrid(
                      color: Colors.deepPurple,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
