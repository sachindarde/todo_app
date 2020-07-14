import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegState extends Equatable {}

class RegInitial extends RegState {
  @override
  List<Object> get props => null;
}

class RegLoading extends RegState {
  @override
  List<Object> get props => null;
}

class RegSuccessful extends RegState {
  bool status;

  RegSuccessful({@required this.status});

  @override
  List<Object> get props => [status];
}

class RegFailure extends RegState {
  String message;

  RegFailure({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
