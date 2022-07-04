import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'door_event.dart';
part 'door_state.dart';

class DoorBloc extends Bloc<DoorEvent, DoorState> {
  DoorBloc() : super(DoorState.open(true)) {
    on<DoorStatusChanged>(_doorStatusChanged);
  }

  // Describes  bloc which handles door actions. Allowing door to be opened, closed, locked and unlocked (=moved back to closed state) depending on emptyDoorway.
  void _doorStatusChanged(DoorStatusChanged event, Emitter<DoorState> emit) {
    // If event is close door and door is open and doorway is empty, close door
    if (event.status == DoorStates.closed &&
        state.state == DoorStates.open &&
        event.doorwayEmpty) {
      emit(DoorState.closed());
    }
    // If event is open door and door is closed, emit open door with doorwayEmpty variable
    else if (event.status == DoorStates.open &&
        state.state == DoorStates.closed &&
        event.doorwayEmpty) {
      emit(DoorState.open(event.doorwayEmpty));
    }
    // If door is closed, and event is locked, lock door
    else if (state.state == DoorStates.closed &&
        event.status == DoorStates.locked) {
      emit(DoorState.locked());
    }
    // If door is locked, and event is unlocked, unlock door (change state to closed)
    else if (state.state == DoorStates.locked &&
        event.status == DoorStates.unlocked) {
      emit(DoorState.closed());
    }
  }
}
