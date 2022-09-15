import 'package:state_machine/state_machine.dart';

StateMachine constructDoorStatemachine() {
  final door = StateMachine('door');

  final isOpen = door.newState('open');
  final isClosed = door.newState('closed');
  final isLocked = door.newState('locked');

  // ignore: unused_local_variable
  Transition open = door.newTransition('open', {isClosed}, isOpen);
  // ignore: unused_local_variable
  Transition close = door.newTransition('close', {isOpen}, isClosed);
  // ignore: unused_local_variable
  Transition lock = door.newTransition('lock', {isClosed}, isLocked);
  // ignore: unused_local_variable
  Transition unlock = door.newTransition('unlock', {isLocked}, isClosed);

  // Pass the doorwayEmpty flag to the state.
  // open.cancelIf((stateChange) => stateChange.payload != true);

  // door.start(isOpen);

  return door;
}
