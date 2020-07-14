import 'package:equatable/equatable.dart';

abstract class ImportantEvent extends Equatable {}

class AppStartEvent extends ImportantEvent {
  @override
  List<Object> get props => null;
}