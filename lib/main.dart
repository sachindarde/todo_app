import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:todo_app/bloc/auth_bloc/auth_event.dart';
import 'package:todo_app/bloc/auth_bloc/auth_state.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/ui/home_screen.dart';
import 'package:todo_app/ui/login_screen.dart';
import 'package:todo_app/ui/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserRepository userRepository = UserRepositoryImpl();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter TodoApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) =>
            AuthBloc(userRepository: userRepository)..add(AppStartEvent()),
        child: MyScreens(
          userRepository: userRepository,
        ),
      ),
    );
  }
}

class MyScreens extends StatelessWidget {
  UserRepository userRepository;

  MyScreens({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is AuthInitState) {
          return SplashScreen();
        } else if (state is AuthenticatedState) {
          return HomeScreen(user: state.user, userRepository: userRepository);
        } else if (state is UnAuthenticatedState) {
          return LoginScreen(userRepository: userRepository);
        }
        return SplashScreen();
      },
    );
  }
}
