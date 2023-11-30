import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmi/pages/forget_password_dialog.dart';
import 'package:hmi/pages/signup_page.dart';
import 'package:hmi/pages/user_profile_page.dart';
import 'package:hmi/utils.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/menu_buttons.dart';
import 'package:hmi/utils/params.dart';
import 'package:hmi/utils/theme.dart';

class LoginPage extends StatefulWidget {
  final String title = "Log In";
  final UserDb userDb;

  const LoginPage({super.key, required this.userDb});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isCheckedRememberForget;
  late bool isUserExists;
  late bool logInByName;
  late bool logInByEmail;

  @override
  void initState() {
    super.initState();
    usernameEmailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordConfirmController = TextEditingController();
    usernameEdited = false;
    isUsernameValid = false;
    passwordEdited = false;
    isPasswordValid = false;
    isCheckedRememberForget = false;
    isUserExists = false;
    logInByName = false;
    logInByEmail = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ...buildBgGeometries(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[buildLoginCard(size)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The function for auth

  void validateUsernameEmail() async {
    String emailPattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp emailRegExp = RegExp(emailPattern, caseSensitive: false);
    logInByEmail = false;
    logInByName = false;
    if (usernameEmailController.text.isEmpty) {
      setState(() {
        usernameEdited = true;
        isUserExists = false;
        logInByEmail = false;
        logInByName = false;
        isUsernameValid = false;
      });
    } else if (emailRegExp.hasMatch(usernameEmailController.text)) {
      // email
      isUserExists =
          await widget.userDb.isUserExists(email: usernameEmailController.text);
      setState(() {
        usernameEdited = true;
        isUserExists = isUserExists;
        logInByEmail = true;
        logInByName = false;
        isUsernameValid =
            usernameEmailController.text.isNotEmpty && isUserExists;
      });
    } else {
      // username
      isUserExists = await widget.userDb
          .isUserExists(username: usernameEmailController.text);
      setState(() {
        usernameEdited = true;
        logInByEmail = false;
        logInByName = true && isUserExists;
        isUsernameValid =
            usernameEmailController.text.isNotEmpty && isUserExists;
      });
    }
  }

  void validatePassword(bool isConfirmPassword) {
    setState(() {
      if (isConfirmPassword) {
        passwordConfirmEdited = true;
        isPasswordMatch =
            passwordController.text == passwordConfirmController.text;
      } else {
        passwordEdited = true;
        isPasswordValid = passwordController.text.isNotEmpty;
      }
    });
  }

  void validateLoginForm() {
    validateUsernameEmail();
    validatePassword(false);
    isFormValid = isUsernameValid && isPasswordValid;
  }

  void authAndLogin() async {
    validateLoginForm();
    if (!isFormValid) {
      return;
    }

    String username = usernameEmailController.text;
    String password = passwordController.text;

    // Show the SnackBar with CircularProgressIndicator when initiating the login process
    loadingSnack(context: context, noteText: "Logging in...");
    widget.userDb.authUser(username: username, password: password).then(
          (authUser) => {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            if (authUser != null)
              {
                // navigate to profile page
                Navigator.pop(context), // This pops the login page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UserProfilePage(userDb: widget.userDb, user: authUser),
                )),
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Login successful!"),
                )),
              }
            else
              {
                // Failed login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Login failed. Invalid credentials."),
                    backgroundColor: Colors.red,
                  ),
                ),
              },
          },
        );
  }

  /// The UI for the login

  Widget buildLoginCard(Size size) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      width: size.width,
      height: size.height * 0.70,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(40, 40),
          topRight: Radius.elliptical(40, 40),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo & login text here
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo(size.height / 8, size.height / 8),
                textLoginPageTitle(24),
              ],
            ),
          ),
          //email , password textField and rememberForget text here
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                usernameEmailTextField(size),
                // Note
                Text(
                  isUsernameValid
                      ? ""
                      : usernameEdited
                          ? usernameEmailController.text.isNotEmpty
                              ? logInByName
                                  ? "Username does not exist."
                                  : logInByEmail
                                      ? "Email does not exist."
                                      : "Username or Email cannot be empty."
                              : "Username or Email cannot be empty."
                          : "",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    height: 0.1,
                    color: dangerColor,
                  ),
                ),
                passwordTextField(size),
                Text(
                  isPasswordValid
                      ? ""
                      : passwordEdited
                          ? "Password cannot be empty."
                          : "",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    height: 0.1,
                    color: dangerColor,
                  ),
                ),

                //remember & forget text
                buildRememberForgetSection(size),
              ],
            ),
          ),

          //login button, 'don't have account' text and social button here
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //login button here
                buildLoginButton(size),
                SizedBox(
                  height: size.height * 0.02,
                ),

                //don't have account text here
                buildNoAccountText(),
                SizedBox(
                  height: size.height * 0.02,
                ),

                //social button here
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: aboutButton(context)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton(Size size) {
    return ElevatedButton(
      onPressed: () => authAndLogin(),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: tertiaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: tertiaryColor.withOpacity(0.3),
        elevation: 5.0,
      ),
      child: SizedBox(
        height: size.height / 13,
        child: Center(
          child: Text(
            'Login In',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget textLoginPageTitle(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: primaryColor,
          letterSpacing: 2,
        ),
        children: const [
          TextSpan(
            text: 'WELCOME',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'BACK',
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Expanded(
            flex: 1,
            child: Divider(
              color: accentColor1,
            )),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignUpPage(userDb: widget.userDb)));
            },
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Don’t have an account?\n'),
                  TextSpan(
                    text: 'Sign Up here',
                    style: TextStyle(color: secondaryColor),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Expanded(
            flex: 1,
            child: Divider(
              color: accentColor1,
            )),
      ],
    );
  }

  /// The UI for global widgets

  Widget usernameEmailTextField(Size size) {
    return SizedBox(
      child: TextField(
        controller: usernameEmailController,
        onChanged: (text) => validateUsernameEmail(),
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: tertiaryColor,
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        cursorColor: tertiaryColor,
        decoration: InputDecoration(
          hintText: "Email or Username",
          hintStyle: GoogleFonts.inter(
            color: tertiaryColor.withOpacity(0.5),
          ),
          fillColor: isUsernameValid
              ? successColor.withOpacity(0.4)
              : usernameEdited
                  ? dangerColor.withOpacity(0.1)
                  : Colors.grey.shade100,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                  color: isUsernameValid
                      ? successColor
                      : usernameEdited
                          ? dangerColor
                          : Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                  color: isUsernameValid
                      ? successColor
                      : usernameEdited
                          ? dangerColor
                          : Colors.transparent)),
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: isUsernameValid
                ? successColor
                : usernameEdited
                    ? dangerColor
                    : tertiaryColor.withOpacity(0.5),
            size: 20,
          ),
          suffix: Container(
            alignment: Alignment.center,
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: isUsernameValid
                    ? successColor
                    : usernameEdited
                        ? dangerColor
                        : Colors.transparent),
            child: isUsernameValid
                ? const Icon(Icons.check, color: Colors.white, size: 13)
                : usernameEdited
                    ? const Icon(Icons.close, color: Colors.white, size: 13)
                    : const Center(),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(Size size, {bool isConfirmPassword = false}) {
    return SizedBox(
      child: TextField(
        controller: passwordController,
        onChanged: (text) => validatePassword(isConfirmPassword),
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: tertiaryColor,
        ),
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        cursorColor: tertiaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: GoogleFonts.inter(
            color: tertiaryColor.withOpacity(0.5),
          ),
          fillColor: isPasswordValid
              ? successColor.withOpacity(0.4)
              : passwordEdited
                  ? dangerColor.withOpacity(0.1)
                  : Colors.grey.shade100,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: isPasswordValid
                    ? successColor
                    : passwordEdited
                        ? dangerColor
                        : Colors.transparent,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: successColor,
              )),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: isPasswordValid
                ? successColor
                : passwordEdited
                    ? dangerColor
                    : tertiaryColor.withOpacity(0.5),
            size: 20,
          ),
          suffix: Container(
            alignment: Alignment.center,
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: isPasswordValid
                  ? successColor
                  : passwordEdited
                      ? dangerColor
                      : Colors.transparent,
            ),
            child: isPasswordValid
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 13,
                  )
                : passwordEdited
                    ? const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 13,
                      )
                    : const Center(),
          ),
        ),
      ),
    );
  }

  Widget buildRememberForgetSection(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCheckedRememberForget = !isCheckedRememberForget;
              });
            },
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: tertiaryColor.withOpacity(0.8),
                  ),
                  child: isCheckedRememberForget
                      ? const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        )
                      : const Center(),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Remember me",
                  style: GoogleFonts.inter(
                    fontSize: 15.0,
                    color: tertiaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => showForgetPasswordDialog(context),
            child: Text(
              "Forgot password?",
              style: GoogleFonts.inter(
                fontSize: 15.0,
                color: tertiaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// list of bg svg
List<Widget> buildBgGeometries() {
  return [
    Positioned(
      left: -26,
      top: 51.0,
      // "assets/images/small3bg.svg"
      child: SvgPicture.asset(
        "assets/images/small1bg.svg",
        width: 91.92,
        height: 91.92,
      ),
    ),
    Positioned(
      right: 43.0,
      top: -103,
      child: SvgPicture.asset(
        "assets/images/small2bg.svg",
        width: 268.27,
        height: 268.27,
      ),
    ),
    Positioned(
      right: -19,
      top: 31.0,
      child: SvgPicture.asset(
        "assets/images/small3bg.svg",
        width: 65.0,
        height: 65.0,
      ),
    ),
  ];
}

Widget logo(double height_, double width_) {
  return SvgPicture.asset(
    "assets/images/logo-pic.svg",
    height: height_,
    width: width_,
  );
}
