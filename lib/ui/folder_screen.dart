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

class FolderScreen extends StatefulWidget {
  User user;
  FileRepository fileRepository;
  String folderSlug;
  String folderName;
  FolderScreen(
      {@required this.user,
      @required this.folderSlug,
      @required this.folderName,
      @required this.fileRepository});

  @override
  _FolderScreen createState() => _FolderScreen(
      user: user,
      folderSlug: folderSlug,
      fileRepository: fileRepository,
      folderName: folderName);
}

class _FolderScreen extends State<FolderScreen> {
  User user;
  FileRepository fileRepository;
  String folderSlug, folderName;
  FileBloc fileBloc;
  TextEditingController titleContr = TextEditingController();

  TextEditingController bodyContr = TextEditingController();

  TextEditingController titleContrUpdate = TextEditingController();

  TextEditingController bodyContrUpdate = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _FolderScreen(
      {@required this.user,
      @required this.fileRepository,
      @required this.folderName,
      @required this.folderSlug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileBloc(fileRepository: fileRepository)
        ..add(LoadFiles(folderSlug: folderSlug)),
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
              fileBloc.add(LoadFiles(folderSlug: folderSlug));
              Navigator.pop(context);
            } else if (state is FileToogleSuccessfulState) {
              fileBloc.add(LoadFiles(folderSlug: folderSlug));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildUI(List<FilesEnitity> list) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _showDialog,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 40),
            ListTile(
              title: Text(
                user.name,
                style: GoogleFonts.nunito(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
              trailing: Container(
                width: 100,
                alignment: Alignment.centerRight,
                child: Text(folderName + "(" + list.length.toString() + ")"),
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
                          border:
                              Border.all(width: 1, color: Color(0xff32a6de)),
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
                              _showDialogUpdate(list[index].slug,
                                  list[index].title, list[index].contentbody);
                            },
                            onLongPress: () {
                              showAlertDialog(list[index].slug);
                            },
                            child: Text(list[index].title),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              fileBloc.add(
                                  ToogleImportantFile(slug: list[index].slug));
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

  _showDialogUpdate(String slug, String title, String body) async {
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
                      folderName: folderName,
                      folderSlug: folderSlug));
                })
          ],
        ),
      ),
    );
  }

  _showDialog() async {
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
                  controller: titleContr,
                  decoration: new InputDecoration(
                      labelText: 'Enter Title', hintText: 'eg. collge'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: TextField(
                    controller: bodyContr,
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
                  fileBloc.add(AddFile(
                      title: titleContr.text,
                      contentbody: bodyContr.text,
                      folderName: folderName,
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
