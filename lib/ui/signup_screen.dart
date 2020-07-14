import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/bloc/register_bloc/reg_bloc.dart';
import 'package:todo_app/bloc/register_bloc/reg_event.dart';
import 'package:todo_app/bloc/register_bloc/reg_state.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/user.dart';
import 'package:todo_app/ui/home_screen.dart';
import 'package:todo_app/ui/login_screen.dart';

class SignupScreen extends StatelessWidget {
  UserRepository userRepository;
  SignupScreen({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegBloc(userRepository: userRepository)..add(AppStartEvent()),
      child: SignupScreenStatefull(userRepository: userRepository),
    );
  }
}

class SignupScreenStatefull extends StatefulWidget {
  UserRepository userRepository;
  SignupScreenStatefull({@required this.userRepository});

  @override
  _SignupScreen createState() => _SignupScreen(userRepository: userRepository);
}

class _SignupScreen extends State<SignupScreenStatefull> {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();

  TextEditingController nameCntrlr = TextEditingController();

  TextEditingController rePassword = TextEditingController();

  UserRepository userRepository;
  _SignupScreen({@required this.userRepository});

  String currentAvatar;

  RegBloc regBloc;
  @override
  void initState() {
    super.initState();
    currentAvatar = "avatar01";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegBloc, RegState>(
        listener: (context, state) {
          if (state is RegSuccessful) {
            navigateToHomePage(context);
          }
        },
        child: BlocBuilder<RegBloc, RegState>(
          builder: (context, state) {
            regBloc = BlocProvider.of<RegBloc>(context);
            if (state is RegInitial) {
              return buildBody(context, false, "");
            } else if (state is RegLoading) {
              return buildBody(context, true, "");
            } else if (state is RegSuccessful) {
              return Container();
            } else if (state is RegFailure) {
              return buildBody(context, false, state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, bool isLoading, String error) {
    return Center(
        child: Stack(children: [
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          Container(
            child: InkWell(
              child: Icon(Icons.arrow_back, size: 30, color: Color(0xff0c8df8)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(top: 50),
          ),
          Container(
              padding: EdgeInsets.only(top: 10, right: 10.0, left: 10.0),
              child: Container(
                  child: Column(children: <Widget>[
                Text(
                  "Create Account",
                  style: GoogleFonts.nunito(
                      color: Color(0xff0c8df8),
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  "Create a new account",
                  style: GoogleFonts.nunito(
                      color: Color(0xffc8cee1),
                      fontSize: 15,
                      fontWeight: FontWeight.w900),
                )
              ]))),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Center(
              child: Text(error, style: GoogleFonts.nunito(color: Colors.red)),
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
                controller: nameCntrlr,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name Here...',
                  labelText: "NAME",
                  labelStyle: GoogleFonts.nunito(fontSize: 13),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color(0xff32a6de),
                    size: 21,
                  ),
                  hintStyle:
                      GoogleFonts.nunito(color: Colors.grey, fontSize: 13),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                ),
              )),
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
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                ),
              )),
          Container(
              width: 320,
              height: 70,
              padding: EdgeInsets.only(bottom: 20.0),
              child: TextField(
                obscureText: true,
                controller: passCntrlr,
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
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                ),
              )),
          Container(
              width: 320,
              height: 70,
              padding: EdgeInsets.only(bottom: 20.0),
              child: TextField(
                obscureText: true,
                controller: rePassword,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password Here...',
                  labelText: "CONFIRM PASSWORD",
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
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Color(0xffc5d0d7), width: 2),
                  ),
                ),
              )),
          Container(
            width: 320,
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    currentAvatar = "avatar01";
                    setState(() {});
                  },
                  child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: Color(0xff32a6de).withAlpha(40)),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Color(0xff32a6de).withOpacity(
                                      currentAvatar == "avatar01" ? 1 : 0.2),
                                  BlendMode.dstATop),
                              image: new NetworkImage(
                                  "https://storage.googleapis.com/s3.codeapprun.io/assets/avatar01.png")))),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    currentAvatar = "avatar02";
                    setState(() {});
                  },
                  child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: Color(0xff32a6de).withAlpha(40)),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Color(0xff32a6de).withOpacity(
                                      currentAvatar == "avatar02" ? 1 : 0.2),
                                  BlendMode.dstATop),
                              image: new NetworkImage(
                                  "https://storage.googleapis.com/s3.codeapprun.io/assets/avatar02.png")))),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    currentAvatar = "avatar03";
                    setState(() {});
                  },
                  child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: Color(0xff32a6de).withAlpha(40)),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Color(0xff32a6de).withOpacity(
                                      currentAvatar == "avatar03" ? 1 : 0.2),
                                  BlendMode.dstATop),
                              image: new NetworkImage(
                                  "https://storage.googleapis.com/s3.codeapprun.io/assets/avatar03.png")))),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    currentAvatar = "avatar04";
                    setState(() {});
                  },
                  child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: Color(0xff32a6de).withAlpha(40)),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Color(0xff32a6de).withOpacity(
                                      currentAvatar == "avatar04" ? 1 : 0.2),
                                  BlendMode.dstATop),
                              image: new NetworkImage(
                                  "https://storage.googleapis.com/s3.codeapprun.io/assets/avatar04.png")))),
                ),
              ],
            ),
          ),
          RaisedButton(
            color: Color(0xff0c8df8),
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text("CREATE ACCOUNT",
                style: GoogleFonts.nunito(
                    color: Color(0xffffffff), fontWeight: FontWeight.w700)),
            onPressed: () {
              regBloc.add(
                SignUpButtonPressedEvent(
                    email: emailCntrl.text,
                    password: passCntrlr.text,
                    avatar: currentAvatar,
                    name: nameCntrlr.text),
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
                        text: "Already hava a account? ",
                        style: GoogleFonts.nunito()),
                    TextSpan(
                        text: "Login",
                        style: GoogleFonts.nunito(color: Color(0xff0c8df8)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
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
    ]));
  }

  void navigateToHomePage(BuildContext context) async {
    User user = await userRepository.authenticatUser();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(user: user, userRepository: userRepository);
    }));
  }
}
