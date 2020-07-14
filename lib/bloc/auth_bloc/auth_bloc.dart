import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/auth_bloc/auth_event.dart';
import 'package:todo_app/bloc/auth_bloc/auth_state.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserRepository userRepository;

  AuthBloc({@required UserRepository userRepository}) : super(null) {
    this.userRepository = userRepository;
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartEvent) {
      try {
        bool isSignin = await userRepository.isSignedIn();
        if (isSignin) {
          User user = await userRepository.authenticatUser();
          yield AuthenticatedState(user: user);
        } else {
          yield UnAuthenticatedState();
        }
      } catch (e) {
        yield UnAuthenticatedState();
      }
    }
  }
}
