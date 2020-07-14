import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/login_bloc/login_event.dart';
import 'package:todo_app/bloc/login_bloc/login_state.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/error_helper.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;

  LoginBloc({@required UserRepository userRepository}) : super(null) {
    this.userRepository = userRepository;
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressedEvent) {
      yield LoginLoading();
      ErrorHelper errorHelper =
          await userRepository.signInUser(event.email, event.password);
      try {
        if (!errorHelper.isError) {
          yield LoginSuccessState(status: true);
        } else {
          yield LoginFailureState(message: errorHelper.error);
        }
      } catch (e) {
        yield LoginFailureState(message: e.toString());
      }
    } else if (event is AppStartEvent) {
      yield LoginInitial();
    }
  }
}
