import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:setapprojects/pages/navBar.dart';
import 'package:setapprojects/pages/user_model.dart';
import 'firebase_options.dart';
import 'signup.dart';
import 'node.dart';
import 'forgotPassword.dart';
import 'main.dart';
import 'profile_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {

  final emailGiven = TextEditingController();
  final passwordGiven = TextEditingController();
  final controller = Get.put(ProfileController());
  
  void clearTextFields() {
    emailGiven.clear();
    passwordGiven.clear();
  }

  @override
  
  Widget build(BuildContext context) {
    clearTextFields();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                "https://cdn3.iconfinder.com/data/icons/network-and-communications-6/130/291-128.png",
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                "Planify",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xff3a57e8),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Log In",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: TextField(
                  controller: emailGiven,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                      BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                      BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                      BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff9e9e9e),
                    ),
                    filled: true,
                    fillColor: Color(0x00f2f2f3),
                    isDense: false,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              TextField(
                controller: passwordGiven,
                obscureText: true,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                    BorderSide(color: Color(0xff9e9e9e), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                    BorderSide(color: Color(0xff9e9e9e), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                    BorderSide(color: Color(0xff9e9e9e), width: 1),
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff9e9e9e),
                  ),
                  filled: true,
                  fillColor: Color(0x00f2f2f3),
                  isDense: false,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    // navigate to forgot password page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff9e9e9e),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        color: Color(0xffffffff),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            color: Color(0xff9e9e9e),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        textColor: Color(0xff000000),
                        height: 40,
                        minWidth: 140,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () async {
                          List<UserModel> userDataList = await ProfileController.instance.getUserData(emailGiven.text);
                          if (userDataList[0].passWord == passwordGiven.text) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          }
                        },
                        color: Color(0xff3a57e8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        textColor: Color(0xffffffff),
                        height: 40,
                        minWidth: 140,
                      ),
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
}
