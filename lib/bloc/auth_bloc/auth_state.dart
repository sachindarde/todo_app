import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/modal/user.dart';

abstract class AuthState extends Equatable {}

class AuthInitState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AuthenticatedState extends AuthState {
  User user;
  AuthenticatedState({@required this.user});
  @override
  List<Object> get props => [user];
}

class UnAuthenticatedState extends AuthState {
  @override
  List<Object> get props => null;
}
