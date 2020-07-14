import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegEvent extends Equatable {}

class SignUpButtonPressedEvent extends RegEvent {
  String email, password, avatar, name;

  SignUpButtonPressedEvent(
      {@required this.email,
      @required this.password,
      @required this.avatar,
      @required this.name});

  @override
  List<Object> get props => null;
}

class AppStartEvent extends RegEvent {
  @override
  List<Object> get props => null;
}
