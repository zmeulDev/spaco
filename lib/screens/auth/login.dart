import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spaco/utils/constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _controller = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "",
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: width * 0.8,
                  child: Image.asset(
                    "assets/images/login.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: const Color(0xffC6C7C4).withOpacity(0.5),
                        ),
                        child: Center(
                          child: TextFormField(
                            controller: _emailController,
                            cursorColor: const Color(0xff6C63FF),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: const Color(0xffC6C7C4).withOpacity(0.5),
                        ),
                        child: Center(
                          child: TextFormField(
                            controller: _passwordController,
                            cursorColor: const Color(0xff6C63FF),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: height * 0.08,
                      width: width * 0.8,
                      child: ElevatedButton(
                        child: const Text("Login"),
                        onPressed: () {
                          _signIn();
                        },
                        style: TextButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: tertiaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 24,
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff5E5E77),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _db.collection("users").doc(user.user!.uid).update({
          "last_seen": DateTime.now(),
        });
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text("Success"),
                content: const Text("Welcome back!"),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: tertiaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
      }).catchError((e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text("Error"),
                content: Text("${e.message}"),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Error"),
              content: const Text("Please provide Email and Password!"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: tertiaryColor,
                    ),
                  ),
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  showRoleDialog(BuildContext context) {
    String? _selectedText;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Select Your Role"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: const Text(
                      "Please choose a role",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    value: _selectedText,
                    items: ['Admin', 'Visitor', 'Member', 'Booking']
                        .map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      setState(() {
                        _selectedText = val!;
                        _controller = _selectedText!;
                      });
                    },
                  ),
                );
              },
              // child: DropdownButton<String>(
              //   value: _selectedText,
              //   items: <String>['Admin', 'User'].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (String? val) {
              //     setState(() {
              //       _selectedText = val!;
              //       _controller = _selectedText;
              //     });
              //   },
              // ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xff6C63FF),
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _signInUsingGoogle();
                },
              ),
            ],
          );
        });
  }

  void _signInUsingGoogle() async {
    print(_controller);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final User? user = (await _auth.signInWithCredential(credential)).user;
      print("Signed In " + user!.displayName.toString());

      if (user != null) {
        //Successful signup
        _db.collection("users").doc(user.uid).set({
          "displayName": user.displayName,
          "email": user.email,
          "role": _controller,
          "last_seen": DateTime.now(),
          "signup_method": user.providerData[0].providerId
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Error"),
              content: Text("${e}"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
  }
}
