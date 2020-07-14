import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FileEvent extends Equatable {}

class LoadFiles extends FileEvent {
  String folderSlug;

  LoadFiles({@required this.folderSlug});

  @override
  List<Object> get props => [folderSlug];
}

class LoadImportantFiles extends FileEvent {
  LoadImportantFiles();

  @override
  List<Object> get props => null;
}

class AddFile extends FileEvent {
  String title;
  String contentbody;
  String folderSlug;
  String folderName;

  AddFile(
      {@required this.title,
      @required this.contentbody,
      @required this.folderName,
      @required this.folderSlug});

  @override
  List<Object> get props => null;
}

class UpdateFile extends FileEvent {
  String title;
  String contentbody;
  String folderSlug;
  String folderName;
  String slug;

  UpdateFile(
      {@required this.title,
      @required this.contentbody,
      @required this.slug,
      @required this.folderName,
      @required this.folderSlug});

  @override
  List<Object> get props => null;
}

class DeleteFile extends FileEvent {
  String slug;

  DeleteFile({@required this.slug});

  @override
  List<Object> get props => null;
}

class ToogleImportantFile extends FileEvent {
  String slug;

  ToogleImportantFile({@required this.slug});

  @override
  List<Object> get props => null;
}
