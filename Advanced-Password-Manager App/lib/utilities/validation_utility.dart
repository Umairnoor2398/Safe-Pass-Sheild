class ValidationUtility {
  static bool isPasswordStrong(String password) {
    // Check if password length is at least 6 characters
    if (password.length < 6) {
      return false;
    }

    // Check if password has at least 1 lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    // Check if password has at least 1 uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    // Check if password has at least 1 special character
    if (!password.contains(RegExp(r'[!@#$%^&*()_+=\[{\]};:<>|./?,-]'))) {
      return false;
    }

    // Check if password has at least 1 digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    return true;
  }

  static bool isValidEmail(String email) {
    // Email regex pattern
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

    return regex.hasMatch(email);
  }
}
