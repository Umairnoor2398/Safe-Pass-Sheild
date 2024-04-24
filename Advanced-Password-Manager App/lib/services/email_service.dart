// ignore_for_file: unused_local_variable

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:safe_pass_sheild/Constants/my_constants.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';

class EmailUtils {
  final smtpServer = gmail(
    'unoor2398@gmail.com',
    'zgbk pmgg rjfl oeqf',
  );

  void sendEmail(
    String email,
    String body,
    String subject,
    bool needsToast,
  ) async {
    final message = Message()
      ..from = const Address('unoor2398@gmail.com', MyConstants.appName)
      ..recipients.add(email)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer).then((value) {
        if (needsToast) {
          MyToast().showSuccess('Email sent successfully');
        }
      });
      // print('Message sent: ${sendReport.sent}');
    } catch (e) {
      if (needsToast) {
        MyToast().showError('Error sending email. Try Again Later.');
      }
    }
  }
}
