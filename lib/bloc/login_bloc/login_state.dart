import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => null;
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => null;
}

class LoginFailureState extends LoginState {
  String message;

  @override
  List<Object> get props => [message];

  LoginFailureState({@required this.message});
}

class LoginSuccessState extends LoginState {
  bool status;

  @override
  List<Object> get props => [status];

  LoginSuccessState({@required this.status});
}
