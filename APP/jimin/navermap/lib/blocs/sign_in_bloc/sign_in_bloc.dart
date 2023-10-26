import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SingInBloc extends Bloc<SingInEvent, SingInState> {
  SingInBloc() : super(SingInInitial()) {
    on<SingInEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
