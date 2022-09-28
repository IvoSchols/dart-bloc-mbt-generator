import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'integer_switch_state.dart';

class IntegerSwitchCubit extends Cubit<IntegerSwitchState> {
  IntegerSwitchCubit() : super(Zero());

  void integerSwitch(int integer) {
    switch (integer) {
      case -20:
        emit(Minus20());
        break;
      case 47:
        emit(FourtySeven());
        break;
      default:
        throw Exception('Woops');
    }
  }
}
