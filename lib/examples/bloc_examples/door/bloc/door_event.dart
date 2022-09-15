part of 'door_bloc.dart';

enum DoorStates { open, closed, locked, unlocked }

/// Events
abstract class DoorEvent extends Equatable {
  const DoorEvent();

  @override
  List<Object> get props => [];
}

class DoorStatusChanged extends DoorEvent {
  final DoorStates status;
  final bool doorwayEmpty;

  DoorStatusChanged(this.status, this.doorwayEmpty);

  @override
  List<Object> get props => [status, doorwayEmpty];
}
