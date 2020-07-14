import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ImportantState extends Equatable {}

class ImportantInitState extends ImportantState {

  @override
  List<Object> get props => null;
}

class ImportantSuccessfulState extends ImportantState {
    
    int count;
    
    ImportantSuccessfulState({@required this.count});

    @override
    List<Object> get props => [count];
}


class ImportantFailureState extends ImportantState {
    
    String message;
    
    ImportantFailureState({@required this.message});
    
    @override
    List<Object> get props => [message];
}
