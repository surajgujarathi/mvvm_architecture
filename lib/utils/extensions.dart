extension ExtString on String {
  bool get isValidNationalID {
    final phoneRegExp = RegExp(r"^[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9_]+\.[a-zA-Z_]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp =
        RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}");
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidSwiftCode {
    final phoneRegExp = RegExp(r"^[A-Z0-9]{6}[A-Z0-9]{2}([A-Z0-9]{3})$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidSSN {
    final phoneRegExp = RegExp(r"^\d{3}-?\d{2}-?\d{4}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidCardNumber {
    final phoneRegExp = RegExp(r"^[0-9]{16}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidAccountNumber {
    final phoneRegExp = RegExp(r"^[0-9]{12}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidCVV {
    final phoneRegExp = RegExp(r"^[0-9]{3}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidMonth {
    final phoneRegExp = RegExp(r"^0*(?:[0-9][0-9]?|12)$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidYear {
    final phoneRegExp = RegExp(r"^[0-9]{4}$");
    return phoneRegExp.hasMatch(this);
  }
}

extension ExtInt on int {
  String convertToKMB(int numValue) {
    if (numValue > 999 && numValue < 99999) {
      return "${(numValue / 1000).toStringAsFixed(1)} K";
    } else if (numValue > 99999 && numValue < 999999) {
      return "${(numValue / 1000).toStringAsFixed(0)} K";
    } else if (numValue > 999999 && numValue < 999999999) {
      return "${(numValue / 1000000).toStringAsFixed(1)} M";
    } else if (numValue > 999999999) {
      return "${(numValue / 1000000000).toStringAsFixed(1)} B";
    } else {
      return numValue.toString();
    }
  }
}

extension ExtDouble on double {
  String convertToKMB(int numValue) {
    if (numValue > 999 && numValue < 99999) {
      return "${(numValue / 1000).toStringAsFixed(1)} K";
    } else if (numValue > 99999 && numValue < 999999) {
      return "${(numValue / 1000).toStringAsFixed(0)} K";
    } else if (numValue > 999999 && numValue < 999999999) {
      return "${(numValue / 1000000).toStringAsFixed(1)} M";
    } else if (numValue > 999999999) {
      return "${(numValue / 1000000000).toStringAsFixed(1)} B";
    } else {
      return numValue.toString();
    }
  }
}

extension ExtDateTime on DateTime {
  bool get isValidDateOfBirth {
    DateTime today = DateTime.now();

    DateTime eligibleDate = DateTime(
        DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
    return eligibleDate.isBefore(today);
  }
}
