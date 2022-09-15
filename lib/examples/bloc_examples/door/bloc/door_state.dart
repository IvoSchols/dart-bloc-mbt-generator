part of 'door_bloc.dart';

// States
class DoorState extends Equatable {
  final DoorStates state;
  final bool doorwayEmpty;

  DoorState.open(this.doorwayEmpty) : state = DoorStates.open;
  DoorState.closed()
      : state = DoorStates.closed,
        doorwayEmpty = true;
  DoorState.locked()
      : state = DoorStates.locked,
        doorwayEmpty = true;

  @override
  List<Object?> get props => [state, doorwayEmpty];
}
