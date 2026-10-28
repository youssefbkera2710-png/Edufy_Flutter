import 'package:edufy/core/constants/string_text.dart';

class ValidatorDef {
  static String? validatorRequired(val) {
    if (val == null || val.toString().trim().isEmpty) {
      return AppString
          .requiredField;
    }
    return null;
  }

  static String? validatorEmail(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterEmail;
    }
    if (!val.contains("@") || !val.contains(".")) {
      return AppString.enterValidEmail;
    }
    return null;
  }

  static String? validatorPassword(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterPassword;
    } else if ((val.toString()).length < 8) {
      return AppString.passwordMinLength;
    } else if ((val.toString()).length > 15) {
      return AppString.passwordMaxLength;
    }
    return null;
  }

  static String? validatorConfirmPassword(String? val, String con) {
    if (val == null || val.isEmpty) {
      return AppString.enterPassword;
    } else if (val != con) {
      return AppString.passwordMismatch;
    }
    return null;
  }

  static String? validatorName(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterName;
    }
    return null;
  }

  static String? validatorLastName(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterLastName;
    }
    return null;
  }

  static String? validatorFatherName(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterFatherName;
    }
    return null;
  }

  static String? validatorPhone(val) {
    if (val == "" || val.isEmpty) {
      return AppString.enterPhone;
    }
    if ((val.toString()).length != 10) {
      return AppString.invalidPhone;
    }
    return null;
  }

  static String? validatorCode(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterCode;
    }
    return null;
  }

  static String? validatorNumber(val) {
    if (val == "" || val.isEmpty) {
      return AppString.enterNumber;
    }
    return null;
  }

  static String? validatorParentPhone(val) {
    if (val == null || val.isEmpty) {
      return AppString.enterPhone;
    }
    if ((val.toString()).length < 10) {
      return AppString.invalidPhone;
    }
    return null;
  }

  static String? validatorRegion(val) {
    if (val == null || val.isEmpty) {
      return AppString.selectRegion;
    }
    return null;
  }

  static String? validatorDate(DateTime? date) {
    if (date == null) {
      return AppString.selectDate;
    }
    return null;
  }
}
