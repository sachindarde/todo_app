import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/register_bloc/reg_event.dart';
import 'package:todo_app/bloc/register_bloc/reg_state.dart';
import 'package:todo_app/dao/user_repository.dart';
import 'package:todo_app/modal/error_helper.dart';

class RegBloc extends Bloc<RegEvent, RegState> {
  UserRepository userRepository;

  RegBloc({@required UserRepository userRepository}) : super(null) {
    this.userRepository = userRepository;
  }

  @override
  Stream<RegState> mapEventToState(RegEvent event) async* {
    if (event is SignUpButtonPressedEvent) {
      yield RegLoading();
      ErrorHelper errorHelper = await userRepository.signUpUser(
          event.email, event.name, event.avatar, event.password);
      try {
        if (!errorHelper.isError) {
          yield RegSuccessful(status: true);
        } else {
          yield RegFailure(message: errorHelper.error);
        }
      } catch (e) {
        yield RegFailure(message: e.toString());
      }
    } else if (event is AppStartEvent) {
      yield RegInitial();
    }
  }
}
