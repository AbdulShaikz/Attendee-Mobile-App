String validateName(String value) {
  if (value.isEmpty) return 'Name is required.';
  final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
  if (!nameExp.hasMatch(value))
    return 'Please enter only alphabetical characters.';
  return null;
}

String validateRollNumber(String value) {
  if (value.isEmpty) return 'Roll Number is required.';
  return null;
}

String validateMobileNumber(String value) {
  if (value.isEmpty)
    return 'Mobile Number is required.';
  else if (value.length < 10) return 'Mobile number should be of 10 digits.';
  return null;
}

String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}

String pwdValidator(String value) {
  if (value.isEmpty) return 'Password is required.';
  if (value.length < 8) {
    return 'Password must be longer than 8 characters';
  } else {
    return null;
  }
}

String validateTutorId(String value) {
  if (value.isEmpty) return 'Tutor id is required.';
  return null;
}

String validateSubjectId(String value) {
  if (value.isEmpty) return 'Subject id is required.';
  final RegExp nameExp = RegExp(r'^[a-zA-Z0-9]+$');
  if (!nameExp.hasMatch(value))
    return 'Please enter only alphabetical characters.';
  return null;
}
