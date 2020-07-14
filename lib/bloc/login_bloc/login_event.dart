import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {}

class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class AppStartEvent extends LoginEvent {
  @override
  List<Object> get props => null;
}

class LoginButtonPressedEvent extends LoginEvent {
  
  String email, password;

  LoginButtonPressedEvent({@required this.email, @required this.password});

  @override
  List<Object> get props => null;
}
