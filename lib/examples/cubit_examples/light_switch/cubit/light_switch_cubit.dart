import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'light_switch_state.dart';

class LightSwitchCubit extends Cubit<LightSwitchState> {
  LightSwitchCubit() : super(Off());

  void lightSwitch(bool on) {
    switch (on) {
      case true:
        emit(On());
        break;
      case false:
        emit(Off());
        break;
    }
  }
}
