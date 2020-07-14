import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/folder_bloc/folder_event.dart';
import 'package:todo_app/bloc/folder_bloc/folder_state.dart';
import 'package:todo_app/dao/folder_repository.dart';
import 'package:todo_app/modal/folders_entity.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderRepository folderRepository;

  FolderBloc({@required FolderRepository folderRepository}) : super(null) {
    this.folderRepository = folderRepository;
  }

  @override
  Stream<FolderState> mapEventToState(FolderEvent event) async* {
    if (event is LoadFolders) {
      yield FolderLoadingState();
      try {
        List<FoldersEntity> list = await folderRepository.getFolders();
        yield FolderSuccessfulState(list: list);
      } catch (e) {
        yield FolderFailureState(message: e.toString());
      }
    } else if (event is AddFolder) {
      yield FolderLoadingState();
      try {
        bool status =
            await folderRepository.saveFolder(event.title, event.colorCode);
        yield FolderAddedSucessfullState(status: status);
      } catch (e) {
        yield FolderFailureState(message: e.toString());
      }
    } else if (event is DeleteFolder) {
      yield FolderLoadingState();
      try {
        bool status = await folderRepository.deleteFolder(event.slug);
        yield FolderAddedSucessfullState(status: status);
      } catch (e) {
        yield FolderFailureState(message: e.toString());
      }
    }
  }
}
