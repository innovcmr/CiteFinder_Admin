import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// This is a file to include all validators for all forms in project

typedef Validatorable = String? Function(String val);

class Validator {
  static String? isRequired(String? val) {
    if (val != null) {
      if (val.isEmpty) return "This field is required";
    }
    return null;
  }

// This validator checks if text has at least 6 characters (for passwords)
  static String? password(String? val) {
    if (val != null) {
      if (val.isEmpty) return "This field is required";
      if (val.length < 6) {
        return "Password length should be at least 6 characters";
      }
    }
    return null;
  }

  static String? phoneNumberOptional(String? val) {
    if (val == null || val.isEmpty) return null;
    if (!GetUtils.isPhoneNumber(val)) {
      return "Invalid Phone Number. Enter valid Phone number or leave field empty";
    }
    return null;
  }

  static String? phoneNumberMandatory(String? val) {
    if (val != null) {
      if (val.isEmpty) return "This field is required";
      if (!GetUtils.isPhoneNumber(val)) return "Invalid Phone Number";
    }
    return null;
  }

  static String? isNumberOptional(String? val) {
    if (val == null || val.isEmpty) return null;
    if (!GetUtils.isNum(val)) {
      return "Invalid value. Enter valid value or leave field empty";
    }
    return null;
  }

  static String? isNumberMandatory(String? val) {
    if (val != null) {
      if (val.isEmpty) return "This field is required";
      if (!GetUtils.isNum(val)) return "Invalid Phone Number";
    }
    return null;
    ;
  }

// This validator checks if a phone number's length(without country code) is = 9 (camerooninan number) add if val!=null to them as requires
//   static String? phone(String val) {
//     if (val.isEmpty) return "This field is required";
//     if (val.length > 9 || val.length < 9 || int.tryParse(val) == null) {
//       return "incorrect_format_phone";
//     }
//     return null;
//   }

//   static String? emailOrPhone(String val) {
//     if (val.isEmpty) return "emptyfield";
//     if (email(val) != null && phone(val) != null) return 'incorrect_format';
//     return null;
//   }

//   static Validatorable greaterThan(int value) {
//     return (String val) {
//       if (val.length < value) return "required_value";
//       return null;
//     };
//   }

//   static Validatorable equalLength(int value) {
//     return (String val) {
//       if (val.length < value) return "emptyfield";
//       return null;
//     };
//   }

//   static Validatorable equalTo(TextEditingController other, [String? msg]) {
//     return (String value) {
//       if (value.compareTo(other.text) != 0) return msg ?? "diff_pass";
//       return null;
//     };
//   }
// this validator checks if the email is valid
  static String? email(String? val) {
    if (val != null) {
      if (val.isEmpty) return "This field is required";
      return RegExp(
                  r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
              .hasMatch(val.trim())
          ? null
          : 'Email is invalid';
    }
    return null;
  }
}

class Formater {
  static FilteringTextInputFormatter deny(String filter,
      [String replacement = '']) {
    return FilteringTextInputFormatter.deny(RegExp(filter),
        replacementString: replacement);
  }

  static FilteringTextInputFormatter allow(String filter,
      [String replacement = '']) {
    return FilteringTextInputFormatter.allow(RegExp(filter),
        replacementString: replacement);
  }
}
