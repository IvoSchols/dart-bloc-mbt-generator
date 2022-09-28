import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'light_switch_deadcode_state.dart';

class LightSwitchDeadcodeCubit extends Cubit<LightSwitchDeadcodeState> {
  LightSwitchDeadcodeCubit() : super(Off());

  void lightSwitch(bool on) {
    switch (on) {
      case true:
        emit(On());
        break;
      case false:
        emit(Off());
        break;
      default:
        throw Exception('Unreachable');
    }
  }
}
