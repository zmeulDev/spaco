import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/utils/constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          color: appBckColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: tertiaryColor,
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: getScreenWidth(context) * 0.6,
                  child: Lottie.asset('assets/animation/login.json'),
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.02,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Container(
                      height: getScreenHeight(context) * 0.07,
                      width: getScreenWidth(context) * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        color: secondaryColor.withOpacity(0.5),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: tertiaryColor,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: tertiaryColor,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Icon(
                              Icons.email_outlined,
                              color: tertiaryColor,
                              size: 25,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  Container(
                    height: getScreenHeight(context) * 0.07,
                    width: getScreenWidth(context) * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: secondaryColor.withOpacity(0.5),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      cursorColor: tertiaryColor,
                      textInputAction: TextInputAction.next,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: tertiaryColor,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Icon(
                            Icons.lock,
                            color: tertiaryColor,
                            size: 25,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.02,
                  ),
                  Container(
                    height: getScreenHeight(context) * 0.07,
                    width: getScreenWidth(context) * 0.5,
                    child: ElevatedButton(
                      child: Text("Create"),
                      onPressed: () {
                        _signUp();
                      },
                      style: TextButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.02,
                  ),
                  TextButton(
                    child: const Text(
                      "Already a member?",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff5E5E77),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/auth");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    final String emailTXT = _emailController.text.trim();
    final String passwordTXT = _passwordController.text;

    if (emailTXT.isNotEmpty && passwordTXT.isNotEmpty) {
      _auth
          .createUserWithEmailAndPassword(
              email: emailTXT, password: passwordTXT)
          .then((user) {
        //Successful signup
        _db.collection("users").doc(user.user!.uid).set({
          "email": emailTXT,
          "last_seen": DateTime.now(),
          "role": "admin",
          "signup_method": user.user!.providerData[0].providerId
        });
        //Show success alert-dialog
        Fluttertoast.showToast(
            msg: "Welcome to spaco!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: colorMsgSuccess,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushNamed(context, "/home");
      }).catchError((e) {
        //Show Errors if any
        Fluttertoast.showToast(
            msg: "${e.message}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: colorMsgWarning,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please check email and password! ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: colorMsgFail,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
