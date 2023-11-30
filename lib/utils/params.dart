import 'package:flutter/material.dart';

late TextEditingController usernameController;
late TextEditingController emailController;
late TextEditingController usernameEmailController;
late TextEditingController passwordController;
late TextEditingController passwordConfirmController;

late bool usernameEdited;
late bool isUsernameValid;
late bool isForbiddenUsername;
late bool emailEdited;
late bool isEmailValid;
late bool isUserExists;
late bool isEmailExists;

late bool passwordEdited;
late bool isPasswordValid;
late bool passwordConfirmEdited;
late bool isPasswordMatch;

late bool isFormValid;
