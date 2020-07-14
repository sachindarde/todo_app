import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/modal/folders_entity.dart';

abstract class FolderState extends Equatable {}

class FolderInitState extends FolderState {
  @override
  List<Object> get props => null;
}

class FolderLoadingState extends FolderState {
  @override
  List<Object> get props => null;
}

class FolderAddedSucessfullState extends FolderState{

  bool status;

  FolderAddedSucessfullState({@required this.status});

  @override
  // TODO: implement props
  List<Object> get props => [status];
  
}

class FolderSuccessfulState extends FolderState {
  List<FoldersEntity> list;

  FolderSuccessfulState({@required this.list});

  @override
  List<Object> get props => [list];
}

class FolderFailureState extends FolderState {
  String message;

  FolderFailureState({@required this.message});

  @override
  List<Object> get props => [message];
}