import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/bloc/file_bloc/file_event.dart';
import 'package:todo_app/bloc/file_bloc/file_state.dart';
import 'package:todo_app/dao/files_repository.dart';
import 'package:todo_app/modal/files_entity.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileRepository fileRepository;

  FileBloc({@required FileRepository fileRepository}) : super(null) {
    this.fileRepository = fileRepository;
  }

  @override
  Stream<FileState> mapEventToState(FileEvent event) async* {
    if (event is LoadFiles) {
      yield FileLoadingState();
      try {
        List<FilesEnitity> list =
            await fileRepository.getFilesFromFolder(event.folderSlug);
        yield FileSuccessfulState(list: list);
      } catch (e) {
        yield FileFailureState(message: e.toString());
      }
    } else if (event is AddFile) {
      yield FileLoadingState();
      try {
        bool status = await fileRepository.addFile(
            event.title, event.contentbody, event.folderSlug, event.folderName);
        yield FileAddedSuccessfulState(status: status);
      } catch (e) {
        yield FileFailureState(message: e.toString());
      }
    } else if (event is DeleteFile) {
      yield FileLoadingState();
      try {
        bool status = await fileRepository.deleteFile(event.slug);
        yield FileAddedSuccessfulState(status: status);
      } catch (e) {
        yield FileFailureState(message: e.toString());
      }
    } else if (event is UpdateFile) {
      yield FileLoadingState();
      try {
        bool status = await fileRepository.updateFile(event.title,
            event.contentbody, event.folderSlug, event.folderName, event.slug);
        yield FileAddedSuccessfulState(status: status);
      } catch (e) {
        yield FileFailureState(message: e.toString());
      }
    } else if (event is ToogleImportantFile) {
      yield FileLoadingState();
      try {
        bool status = await fileRepository.toogleImpoartant(event.slug);
        yield FileToogleSuccessfulState(status: status);
      } catch (e) {
        yield FileFailureState(message: e.toString());
      }
    } else if (event is LoadImportantFiles) {
      yield FileLoadingState();
      try {
        List<FilesEnitity> list = await fileRepository.loadImpoartantFiles();
        yield FileSuccessfulState(list: list);
      } catch (e) {
        yield FileFailureState(message: e.toString());
      }
    }
  }
}
