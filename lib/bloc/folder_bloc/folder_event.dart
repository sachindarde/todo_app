import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FolderEvent extends Equatable {}

class LoadFolders extends FolderEvent {
  @override
  List<Object> get props => null;
}

class AddFolder extends FolderEvent {
  String title;
  String colorCode;

  AddFolder({@required this.title, @required this.colorCode});

  @override
  List<Object> get props => null;
}

class DeleteFolder extends FolderEvent {
  String slug;

  DeleteFolder({@required this.slug});

  @override
  List<Object> get props => null;
}
