import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/important_bloc/important_event.dart';
import 'package:todo_app/bloc/important_bloc/important_state.dart';
import 'package:todo_app/dao/files_repository.dart';

class ImportantBloc extends Bloc<ImportantEvent, ImportantState> {
  FileRepository fileRepository;

  ImportantBloc({@required FileRepository fileRepository}) : super(null) {
    this.fileRepository = fileRepository;
  }

  @override
  Stream<ImportantState> mapEventToState(ImportantEvent event) async* {
    if (event is AppStartEvent) {
      yield ImportantInitState();
      try {
        int count = await fileRepository.getImportantCount();
        yield ImportantSuccessfulState(count: count);
      } catch (e) {
        yield ImportantFailureState(message:e.toString());
      }
    }
  }
}
