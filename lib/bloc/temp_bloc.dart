import 'package:flutter_bloc/flutter_bloc.dart';
import 'temp_event.dart';
import 'temp_state.dart';

class TempBloc extends Bloc<TempEvent, TempState> {
  TempBloc() : super(const TempState()) {
    on<InputChanged>((event, emit) => emit(TempState(input: event.val, dari: state.dari)));
    on<UnitChanged>((event, emit) => emit(TempState(input: state.input, dari: event.unit)));
  }
}