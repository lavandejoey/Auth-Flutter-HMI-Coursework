bool isNotForbiddenCriteria(String str) {
  List<String> forbiddenNames = [
    r"^Joshua$",
    r"^Flutter$",
    r"^Android$",
    r"^Linux$",
    r"^Windows$",
    r"^macOS$",
    r"^Flask$",
    r"^admin$",
    r"^root$",
    r"^sudo$",
    r"^password$",
  ];
  // Create a regular expression pattern by joining the forbidden names with pipe (|)
  String pattern = forbiddenNames.join('|');
  String emailPattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
  // Use a case-insensitive regular expression to check for forbidden criteria
  RegExp regExp = RegExp(pattern, caseSensitive: false);
  RegExp emailRegExp = RegExp(emailPattern, caseSensitive: false);
  // Check if the input string matches any forbidden name or a email type
  return !regExp.hasMatch(str) && !emailRegExp.hasMatch(str);
}
