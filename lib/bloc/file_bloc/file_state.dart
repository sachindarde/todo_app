import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/modal/files_entity.dart';

abstract class FileState extends Equatable {}

class FileInitState extends FileState {
  @override
  List<Object> get props => null;
}

class FileLoadingState extends FileState {
  @override
  List<Object> get props => null;
}

class FileAddedSuccessfulState extends FileState {
  bool status;

  FileAddedSuccessfulState({@required this.status});

  @override
  // TODO: implement props
  List<Object> get props => [status];
}

class FileToogleSuccessfulState extends FileState {
  bool status;

  FileToogleSuccessfulState({@required this.status});

  @override
  // TODO: implement props
  List<Object> get props => [status];
}

class FileSuccessfulState extends FileState {
  List<FilesEnitity> list;

  FileSuccessfulState({@required this.list});

  @override
  List<Object> get props => [list];
}

class FileFailureState extends FileState {
  String message;

  FileFailureState({@required this.message});

  @override
  List<Object> get props => [message];
}
