import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/bloc/login_bloc/login_bloc.dart';
import 'package:todo_app/bloc/login_bloc/login_event.dart';
import 'package:todo_app/bloc/login_bloc/login_state.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/user.dart';
import 'package:todo_app/ui/home_screen.dart';
import 'package:todo_app/ui/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  UserRepository userRepository;
  LoginScreen({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(userRepository: userRepository)..add(AppStartEvent()),
      child: _LoginScreen(userRepository: userRepository),
    );
  }
}

class _LoginScreen extends StatelessWidget {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();

  LoginBloc loginBloc;

  UserRepository userRepository;
  _LoginScreen({@required this.userRepository});
  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            navigateToHomePage(context);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitial) {
              return buildBody(context, false, "");
            } else if (state is LoginLoading) {
              return buildBody(context, true, "");
            } else if (state is LoginSuccessState) {
              return Container();
            } else if (state is LoginFailureState) {
              return buildBody(context, false, state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context, bool isLoading, String error) {
    return Center(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            children: [
              Container(
                  padding: EdgeInsets.only(top: 80, right: 10.0, left: 10.0),
                  child: Container(
                      child: Column(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Image.network(
                            "https://storage.googleapis.com/s3.codeapprun.io/userassets/sachindarde/zDdaMNIUETimg.png",
                            height: 100.0)),
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.nunito(
                          color: Color(0xff0c8df8),
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      "Sign to continue",
                      style: GoogleFonts.nunito(
                          color: Color(0xffc8cee1),
                          fontSize: 15,
                          fontWeight: FontWeight.w900),
                    )
                  ]))),
              SizedBox(
                height: 45,
              ),
              Container(
                child: Center(
                  child:
                      Text(error, style: GoogleFonts.nunito(color: Colors.red)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: 320,
                  height: 70,
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    autocorrect: true,
                    controller: emailCntrl,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Here...',
                      labelText: "EMAIL",
                      labelStyle: GoogleFonts.nunito(fontSize: 13),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xff32a6de),
                        size: 21,
                      ),
                      hintStyle:
                          GoogleFonts.nunito(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(color: Color(0xffc5d0d7), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(color: Color(0xffc5d0d7), width: 2),
                      ),
                    ),
                  )),
              Container(
                  width: 320,
                  height: 70,
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: passCntrlr,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password Here...',
                      labelText: "PASSWORD",
                      labelStyle: GoogleFonts.nunito(fontSize: 13),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xff32a6de),
                        size: 21,
                      ),
                      hintStyle:
                          GoogleFonts.nunito(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(color: Color(0xffc5d0d7), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(color: Color(0xffc5d0d7), width: 2),
                      ),
                    ),
                  )),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.nunito(
                      color: Color(0xff0c8df8), fontSize: 14),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                color: Color(0xff0c8df8),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("LOGIN",
                    style: GoogleFonts.nunito(
                        color: Color(0xffffffff), fontWeight: FontWeight.w700)),
                onPressed: () {
                  loginBloc.add(
                    LoginButtonPressedEvent(
                      email: emailCntrl.text,
                      password: passCntrlr.text,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                            text: "Don't have account? ",
                            style: GoogleFonts.nunito()),
                        TextSpan(
                            text: "Create a new account",
                            style: GoogleFonts.nunito(color: Color(0xff0c8df8)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen(
                                            userRepository: userRepository,
                                          )),
                                );
                              }),
                      ]),
                ),
              ),
            ],
          ),
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }

  void navigateToHomePage(BuildContext context) async {
    User user = await userRepository.authenticatUser();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(user: user, userRepository: userRepository);
    }));
  }
}
