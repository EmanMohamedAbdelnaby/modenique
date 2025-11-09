class Validator {
  static String? validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]{6,}@gmail\.com$');

    if (email.isEmpty) {
      return AppStrings.emailRequired;
    } else if (!email.split("@")[0].contains(RegExp(r'^.{6,}$'))) {
      return AppStrings.emailMinLength;
    } else if (!regex.hasMatch(email)) {
      if (!email.contains("@gmail.com")) {
        return AppStrings.emailMustEndGmail;
      } else {
        return AppStrings.emailInvalidFormat;
      }
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (password.length < 8) {
      return AppStrings.passwordAtLeast8Char;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return AppStrings.passwordAtLeast1Uppercase;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return AppStrings.passwordAtLeast1Lowercase;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return AppStrings.passwordAtLeast1Number;
    }
    if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
      return AppStrings.passwordAtLeast1SpecialChar;
    }
    // if (passwordController.text != confirmPassController.text) {
    //   return AppStrings.passwordNotTheSame;
    // }
    return null;
  }

  static String? validateID(String id) {
    final regex = RegExp(r'^\d{14}$');

    if (id.isEmpty) {
      return AppStrings.idRequired;
    } else if (!regex.hasMatch(id)) {
      return AppStrings.idInvalid;
    }
    return null;
  }

  static String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return AppStrings.phoneRequired;
    }
    if (!RegExp(r'^01[0125]').hasMatch(phoneNumber)) {
      return AppStrings.phoneInvalidStart;
    }
    if (phoneNumber.length != 11) {
      return AppStrings.phoneInvalidLength;
    }
    if (!RegExp(r'^\d{11}$').hasMatch(phoneNumber)) {
      return AppStrings.phoneInvalidFormat;
    }
    return null;
  }

  static String? validateUserName(String userName) {
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_ ]{2,}$');
    if (userName.isEmpty) {
      return AppStrings.usernameRequired;
    } else if (!RegExp(r'^[a-zA-Z]').hasMatch(userName)) {
      return AppStrings.usernameMustStartWithLetter;
    } else if (userName.length < 3) {
      return AppStrings.usernameMinLength;
    } else if (!regex.hasMatch(userName)) {
      return AppStrings.usernameInvalidFormat;
    } else if (userName.replaceAll(RegExp(r'[^a-zA-Z]'), '').length < 3) {
      return AppStrings.usernameMustContainAtLeast3Letters;
    }
    return null;
  }
}

class AppStrings {
  //* validation messages
  static const String emailRequired = "Email is required";
  static const String emailMinLength =
      "The part before @ must be at least 6 characters long";
  static const String emailMustEndGmail = "Email must end with @gmail.com";
  static const String emailInvalidFormat = "Invalid email format";
  static const String idRequired = "ID is required.";
  static const String idInvalid =
      "ID must be exactly 14 digits long and contain only numbers.";
  static const String phoneRequired = "Phone number is required.";
  static const String phoneInvalidStart =
      "Phone number must start with '01' followed by 0, 1, 2, or 5.";
  static const String phoneInvalidLength =
      "Phone number must be exactly 11 digits long.";
  static const String phoneInvalidFormat =
      "Phone number can only contain numbers.";
  static const String usernameRequired = "Username is required.";
  static const String usernameMinLength =
      "Username must be at least 3 characters long.";
  static const String usernameMustStartWithLetter =
      "Username must start with a letter.";
  static const String usernameMustContainAtLeast3Letters =
      "Username must contain at least 3 letters.";
  static const String usernameInvalidFormat =
      "Username can only contain letters and numbers.";
  static const String passwordAtLeast8Char =
      'Password must be at least 8 characters long.';
  static const String passwordAtLeast1Uppercase =
      'Password must contain at least one uppercase letter.';
  static const String passwordAtLeast1Lowercase =
      'Password must contain at least one lowercase letter.';
  static const String passwordAtLeast1Number =
      'Password must contain at least one number.';
  static const String passwordAtLeast1SpecialChar =
      'Password must contain at least one special character.';
  static const String passwordNotTheSame =
      "Password and confirm password must be the same.";
  static const String emailError = 'Please enter a valid email address';
  static const String fieldRequired = 'This field is required.';
  static const String nameError =
      'Please enter a valid name (letters and spaces only)';
}
