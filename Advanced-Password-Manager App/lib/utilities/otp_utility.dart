import 'dart:math';

import 'package:safe_pass_sheild/services/email_service.dart';

class OTPUtility {
  static String GenerateOTP(String email) {
    Random random = Random();

    // Generate a random integer between a specified range (e.g., 1 to 100)
    int min = 123456;
    int max = 999999;
    int randomInteger = min + random.nextInt(max - min + 1);
    String otp = randomInteger.toString();

    // sendOtpEmail(email, otp);
    otp = '123456'; // For testing purposes

    return otp;
  }

  static Future<void> sendOtpEmail(String email, String otp) async {
    EmailUtils()
        .sendEmail(email, 'Your OTP is: $otp', 'OTP Verification', true);
  }
}
