import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/bloc/folder_bloc/folder_bloc.dart';
import 'package:todo_app/bloc/folder_bloc/folder_event.dart';
import 'package:todo_app/bloc/folder_bloc/folder_state.dart';
import 'package:todo_app/bloc/important_bloc/important_bloc.dart';
import 'package:todo_app/bloc/important_bloc/important_event.dart';
import 'package:todo_app/bloc/important_bloc/important_state.dart';
import 'package:todo_app/dao/files_repository.dart';
import 'package:todo_app/dao/folder_repository.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/folders_entity.dart';
import 'package:todo_app/modal/user.dart';
import 'package:todo_app/ui/folder_screen.dart';
import 'package:todo_app/ui/important_screen.dart';
import 'package:todo_app/ui/login_screen.dart';

class HomeScreen extends StatefulWidget {
  User user;
  UserRepository userRepository;
  HomeScreen({@required this.user, @required this.userRepository});

  @override
  _HomeScreen createState() =>
      _HomeScreen(user: user, userRepository: userRepository);
}

class _HomeScreen extends State<HomeScreen> {
  User user;
  UserRepository userRepository;

  FileRepository fileRepository = FileRepositoryImpl();
  FolderRepository folderRepository = FolderRepositoryImpl();

  TextEditingController titleContr = TextEditingController();
  FolderBloc folderBloc;

  ImportantBloc importantBloc;

  Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = Color(0xFFE5FCC2);
  }

  void changeColor(Color color) => setState(() => currentColor = color);

  _HomeScreen({@required this.user, @required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                child: BlocProvider(
                  create: (context) =>
                      ImportantBloc(fileRepository: fileRepository)
                        ..add(AppStartEvent()),
                  child: BlocListener<ImportantBloc, ImportantState>(
                    listener: (context, state) {
                      if (state is ImportantFailureState) {
                        //navigateToHomePage(context);//not login
                      }
                    },
                    child: BlocBuilder<ImportantBloc, ImportantState>(
                      builder: (context, state) {
                        importantBloc = BlocProvider.of<ImportantBloc>(context);
                        if (state is ImportantInitState) {
                          return Text("Loading...");
                        } else if (state is ImportantSuccessfulState) {
                          return InkWell(
                            onTap: () async {
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ImportantScreen(
                                  user: user,
                                  fileRepository: fileRepository,
                                );
                              }));
                              importantBloc.add(AppStartEvent());
                            },
                            child: Text(
                                "Important(" + state.count.toString() + ")"),
                          );
                        } else if (state is ImportantFailureState) {
                          return Text("failed");
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
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
                                    ".png")))),
              ),
            ),
            BlocProvider(
              create: (context) =>
                  FolderBloc(folderRepository: folderRepository)
                    ..add(LoadFolders()),
              child: BlocListener<FolderBloc, FolderState>(
                listener: (context, state) {
                  if (state is FolderFailureState) {
                    //navigateToHomePage(context);//not login
                  }
                },
                child: BlocBuilder<FolderBloc, FolderState>(
                  builder: (context, state) {
                    folderBloc = BlocProvider.of<FolderBloc>(context);
                    if (state is FolderInitState) {
                      return Container();
                    } else if (state is FolderSuccessfulState) {
                      return SingleChildScrollView(
                        child: buildUI(context, state.list),
                      );
                    } else if (state is FolderFailureState) {
                      return Container();
                    } else if (state is FolderAddedSucessfullState) {
                      folderBloc.add(LoadFolders());
                      importantBloc.add(AppStartEvent());
                      Navigator.pop(context);
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUI(BuildContext context, List<FoldersEntity> list) {
    if (list.length == 0) {
      return Container(
        child: Center(
          child: Image.asset("lib/res/assets/nofolder.jpg"),
        ),
      );
    } else {
      return Container(
          height: MediaQuery.of(context).size.height - 96,
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(list.length, (index) {
              return InkWell(
                child: Stack(
                  children: [
                    Container(
                      color: Color(int.parse(list[index].colorCode)),
                      margin: EdgeInsets.only(
                          top: 5, bottom: 30, left: 5, right: 5),
                      child: Center(
                        child: Icon(
                          Icons.folder_open,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          list[index].title,
                          style: GoogleFonts.nunito(fontSize: 17),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
                onLongPress: () {
                  showAlertDialog(list[index].slug);
                },
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return FolderScreen(
                      user: user,
                      folderName: list[index].title,
                      fileRepository: fileRepository,
                      folderSlug: list[index].slug,
                    );
                  }));
                  importantBloc.add(AppStartEvent());
                },
              );
            }),
          ));
    }
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
        folderBloc.add(DeleteFolder(slug: slug));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
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

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            height: 160,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 70),
                  child: BlockPicker(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                    availableColors: [
                      Color(0xFFE5FCC2),
                      Color(0xFF9DE0AD),
                      Color(0xFF45ADA8),
                      Color(0xFFFE4365)
                    ],
                  ),
                ),
                new TextField(
                  autofocus: true,
                  controller: titleContr,
                  decoration: new InputDecoration(
                      labelText: 'Enter Title', hintText: 'eg. collge'),
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
                  folderBloc.add(AddFolder(
                      colorCode: currentColor.value.toString(),
                      title: titleContr.text));
                })
          ],
        ),
      ),
    );
  }

  void navigateToLogin(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginScreen(userRepository: userRepository);
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
