import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class AppStartEvent extends AuthEvent {
  @override
  List<Object> get props => null;
}