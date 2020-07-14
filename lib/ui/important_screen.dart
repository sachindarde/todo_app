import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/bloc/file_bloc/file_bloc.dart';
import 'package:todo_app/bloc/file_bloc/file_event.dart';
import 'package:todo_app/bloc/file_bloc/file_state.dart';
import 'package:todo_app/dao/files_repository.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/files_entity.dart';
import 'package:todo_app/modal/user.dart';
import 'package:todo_app/ui/login_screen.dart';

class ImportantScreen extends StatefulWidget {
  User user;
  FileRepository fileRepository;
  String folderSlug;
  String folderName;
  ImportantScreen({@required this.user, @required this.fileRepository});

  @override
  _ImportantScreen createState() =>
      _ImportantScreen(user: user, fileRepository: fileRepository);
}

class _ImportantScreen extends State<ImportantScreen> {
  User user;
  FileRepository fileRepository;
  FileBloc fileBloc;
  TextEditingController titleContr = TextEditingController();

  TextEditingController bodyContr = TextEditingController();

  TextEditingController titleContrUpdate = TextEditingController();

  TextEditingController bodyContrUpdate = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _ImportantScreen({@required this.user, @required this.fileRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FileBloc(fileRepository: fileRepository)..add(LoadImportantFiles()),
      child: BlocListener<FileBloc, FileState>(
        listener: (context, state) {
          if (state is FileInitState) {
            //navigateToHomePage(context);//not login
          }
        },
        child: BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            fileBloc = BlocProvider.of<FileBloc>(context);
            if (state is FileInitState) {
              return Container(
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 10,
                  ),
                ),
              );
            } else if (state is FileSuccessfulState) {
              return buildUI(state.list);
            } else if (state is FileFailureState) {
              return Container(
                child: Center(
                  child: Text("Failed"),
                ),
              );
            } else if (state is FileAddedSuccessfulState) {
              fileBloc.add(LoadImportantFiles());
              Navigator.pop(context);
            } else if (state is FileToogleSuccessfulState) {
              fileBloc.add(LoadImportantFiles());
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildUI(List<FilesEnitity> list) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        SizedBox(height: 40),
        ListTile(
          title: Text(
            user.name,
            style: GoogleFonts.nunito(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.w800),
          ),
          trailing: Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: Text("Important(" + list.length.toString() + ")"),
          ),
          leading: InkWell(
              onTap: () {
                logoutDialog();
              },
              child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Color(0xff32a6de)),
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              "https://storage.googleapis.com/s3.codeapprun.io/assets/" +
                                  user.imageUrl +
                                  ".png"))))),
        ),
        Container(
            height: MediaQuery.of(context).size.height - 96,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                      title: InkWell(
                        onTap: () {
                          _showDialogUpdate(
                              list[index].slug,
                              list[index].title,
                              list[index].contentbody,
                              list[index].folderSlug,
                              list[index].folderTitle);
                        },
                        onLongPress: () {
                          showAlertDialog(list[index].slug);
                        },
                        child: Text(list[index].title +
                            " (Folder: " +
                            list[index].folderTitle +
                            ")"),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          fileBloc
                              .add(ToogleImportantFile(slug: list[index].slug));
                        },
                        child: Icon(
                          list[index].isImportant
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.yellow,
                        ),
                      ));
                }))
      ]),
    ));
  }

  _showDialogUpdate(String slug, String title, String body, String folderSlug,
      String folderTitle) async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            height: 200,
            child: Stack(
              children: [
                TextField(
                  autofocus: true,
                  controller: titleContrUpdate..text = title,
                  decoration: new InputDecoration(
                      labelText: 'Enter Title', hintText: 'eg. collge'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: TextField(
                    controller: bodyContrUpdate..text = body,
                    maxLines: 5,
                    decoration: new InputDecoration(
                        labelText: 'Todo', hintText: 'Write your Todo here!'),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('CREATE'),
                onPressed: () {
                  fileBloc.add(UpdateFile(
                      title: titleContrUpdate.text,
                      slug: slug,
                      contentbody: bodyContrUpdate.text,
                      folderName: folderTitle,
                      folderSlug: folderSlug));
                })
          ],
        ),
      ),
    );
  }

  logoutDialog() {
    Widget cancelButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: () async {
        FlutterSecureStorage storage = FlutterSecureStorage();
        storage.delete(
          key: "jwt_token",
        );
        navigateToLogin(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Really want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(String slug) {
    Widget cancelButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("DELETE"),
      onPressed: () {
        fileBloc.add(DeleteFile(slug: slug));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Really want to delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void navigateToLogin(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginScreen(userRepository: UserRepositoryImpl());
    }));
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        padding: EdgeInsets.all(10),
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
