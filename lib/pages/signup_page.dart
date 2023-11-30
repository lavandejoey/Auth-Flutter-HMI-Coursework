import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmi/pages/user_profile_page.dart';
import 'package:hmi/utils.dart';
import 'package:hmi/utils/database.dart';
import 'package:hmi/utils/menu_buttons.dart';
import 'package:hmi/utils/params.dart';
import 'package:hmi/utils/theme.dart';
import 'package:hmi/utils/user_model.dart';
import 'package:hmi/utils/validation.dart';

class SignUpPage extends StatefulWidget {
  final String title = "Sign Up";
  final UserDb userDb;

  const SignUpPage({super.key, required this.userDb});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late bool isCheckedRememberForget;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    usernameEdited = false;
    isUsernameValid = false;
    emailController = TextEditingController();
    emailEdited = false;
    isEmailValid = false;
    passwordController = TextEditingController();
    passwordEdited = false;
    isPasswordValid = false;
    passwordConfirmController = TextEditingController();
    passwordConfirmEdited = false;
    isPasswordMatch = false;

    isFormValid = false;
    isUserExists = false;
    isEmailExists = false;
    isForbiddenUsername = false;
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
              Positioned(
                top: 20.0,
                left: 20.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
              //bg design, we use 3 svg img
              ...buildBgGeometries(),
              //card and footer ui
              Center(
                // bottom: 20.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    buildCard(size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The function for sign up

  void validateUsername() async {
    bool isLegalName = isNotForbiddenCriteria(usernameController.text) &&
        // 4-32 characters
        usernameController.text.length >= 4 &&
        usernameController.text.length <= 32;
    if (!isLegalName) {
      setState(() {
        usernameEdited = true;
        isForbiddenUsername = !isLegalName;
        isUsernameValid = false;
      });
      return;
    }
    isUserExists =
        await widget.userDb.isUserExists(username: usernameController.text);
    setState(() {
      usernameEdited = true;
      isForbiddenUsername = !isLegalName;
      isUsernameValid = isLegalName && !isUserExists;
    });
  }

  void validateEmail() {
    String emailPattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regExp = RegExp(emailPattern);
    setState(() {
      emailEdited = true;
      isEmailValid = regExp.hasMatch(emailController.text);
    });
  }

  void validatePassword() {
    setState(() {
      passwordEdited = true;
      isPasswordValid = passwordController.text.isNotEmpty;
    });
  }

  void validatePasswordConfirm() {
    setState(() {
      passwordConfirmEdited = true;
      isPasswordMatch =
          passwordConfirmController.text == passwordController.text &&
              passwordConfirmController.text.isNotEmpty;
    });
  }

  void validateForm() {
    validateUsername();
    validateEmail();
    validatePassword();
    validatePasswordConfirm();
    isFormValid =
        isUsernameValid && isEmailValid && isPasswordValid && isPasswordMatch;
  }

  void authAndSignUp() async {
    validateForm();
    if (!isFormValid) {
      return;
    }

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Show the SnackBar with CircularProgressIndicator when initiating the signup process
    loadingSnack(context: context, noteText: "Creating account...");
    widget.userDb
        .insertUser(User(
          username: username,
          email: email,
          password: password,
          createdAt: '',
          updatedAt: '',
        ))
        .then((newUser) => {
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              if (newUser != null)
                {
                  // navigate to profile page
                  Navigator.popUntil(context, (route) => route.isFirst),
                  // pop all routes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserProfilePage(userDb: widget.userDb, user: newUser),
                    ),
                  ),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account created!"),
                    ),
                  ),
                }
              else
                {
                  // Failed signup
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account creation failed."),
                      backgroundColor: Colors.red,
                    ),
                  ),
                },
            });
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

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      width: size.width,
      height: size.height * 0.86,
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
          //logo & sign up text here
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo(size.height / 20, size.height / 20),
                textSignUpPageTitle(24),
              ],
            ),
          ),
          //email , password textField and rememberForget text here
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                usernameTextField(size),
                Text(
                  isUsernameValid
                      ? ""
                      : usernameEdited
                          ? isForbiddenUsername
                              ? "Username is not allowed." // invalid->edited->forbidden
                              : isUserExists
                                  ? "Username already exists." // invalid->edited->not forbidden->exists
                                  : "Username must be 4-32 characters." // invalid->edited->not forbidden
                          : "", // invalid->not edited
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    height: 0.5,
                    color: dangerColor,
                  ),
                ),
                emailTextField(size),
                Text(
                  isEmailValid
                      ? ""
                      : emailEdited
                          ? isEmailExists
                              ? "Email already exists." // invalid->edited->exists
                              : "Email is not valid." // invalid->edited->not exists
                          : "", // invalid->not edited
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    height: 0.5,
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
                    height: 0.5,
                    color: dangerColor,
                  ),
                ),
                passwordConfirmTextField(size),
                Text(
                  isPasswordMatch
                      ? ""
                      : passwordConfirmEdited
                          ? "Please make sure your passwords match."
                          : "",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    height: 0.5,
                    color: dangerColor,
                  ),
                ),
              ],
            ),
          ),

          //sign in button, 'don't have account' text and social button here
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //sign in button here
                buildSignUpButton(size),
                SizedBox(
                  height: size.height * 0.02,
                ),

                //don't have account text here
                buildAlreadyHaveAccountText(),
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

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      "assets/images/logo-pic.svg",
      height: height_,
      width: width_,
    );
  }

  Widget textSignUpPageTitle(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          letterSpacing: 2,
        ),
        children: const [
          TextSpan(
            text: "HELLO",
            style: TextStyle(color: accentColor2, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "THERE",
            style: TextStyle(color: accentColor1, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget usernameTextField(Size size) {
    return SizedBox(
      child: TextField(
        controller: usernameController,
        onChanged: (text) => {validateUsername()},
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: tertiaryColor,
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        cursorColor: tertiaryColor,
        decoration: InputDecoration(
          hintText: "Username",
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

  Widget emailTextField(Size size) {
    return SizedBox(
      child: TextField(
        controller: emailController,
        onChanged: (text) => validateEmail(),
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: tertiaryColor,
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        cursorColor: tertiaryColor,
        decoration: InputDecoration(
          hintText: "Email",
          hintStyle: GoogleFonts.inter(
            color: tertiaryColor.withOpacity(0.5),
          ),
          fillColor: isEmailValid
              ? successColor.withOpacity(0.4)
              : emailEdited
                  ? dangerColor.withOpacity(0.1)
                  : Colors.grey.shade100,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                  color: isEmailValid
                      ? successColor
                      : emailEdited
                          ? dangerColor
                          : Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                  color: isEmailValid
                      ? successColor
                      : emailEdited
                          ? dangerColor
                          : Colors.transparent)),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: isEmailValid
                ? successColor
                : emailEdited
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
                color: isEmailValid
                    ? successColor
                    : emailEdited
                        ? dangerColor
                        : Colors.transparent),
            child: isEmailValid
                ? const Icon(Icons.check, color: Colors.white, size: 13)
                : emailEdited
                    ? const Icon(Icons.close, color: Colors.white, size: 13)
                    : const Center(),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return SizedBox(
      child: TextField(
        controller: passwordController,
        onChanged: (text) => {
          validatePassword(),
          passwordConfirmController.text.isNotEmpty
              ? validatePasswordConfirm()
              : null
        },
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

  Widget passwordConfirmTextField(Size size) {
    return SizedBox(
      child: TextField(
        controller: passwordConfirmController,
        onChanged: (text) => validatePasswordConfirm(),
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: tertiaryColor,
        ),
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        cursorColor: tertiaryColor,
        decoration: InputDecoration(
          hintText: "Confirm Password",
          hintStyle: GoogleFonts.inter(
            color: tertiaryColor.withOpacity(0.5),
          ),
          fillColor: isPasswordMatch
              ? successColor.withOpacity(0.4)
              : passwordConfirmEdited
                  ? dangerColor.withOpacity(0.1)
                  : Colors.grey.shade100,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: isPasswordMatch
                    ? successColor
                    : passwordConfirmEdited
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
            color: isPasswordMatch
                ? successColor
                : passwordConfirmEdited
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
              color: isPasswordMatch
                  ? successColor
                  : passwordConfirmEdited
                      ? dangerColor
                      : Colors.transparent,
            ),
            child: isPasswordMatch
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 13,
                  )
                : passwordConfirmEdited
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

  Widget buildSignUpButton(Size size) {
    return ElevatedButton(
      onPressed: () => authAndSignUp(),
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
            "Sign Up",
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

  Widget buildAlreadyHaveAccountText() {
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
              Navigator.of(context).pop();
            },
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Already have an account? "),
                  TextSpan(
                    text: "Log In here",
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
}
