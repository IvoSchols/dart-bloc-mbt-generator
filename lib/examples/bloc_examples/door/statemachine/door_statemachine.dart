import 'package:state_machine/state_machine.dart';

StateMachine constructDoorStatemachine() {
  final door = StateMachine('door');

  final isOpen = door.newState('open');
  final isClosed = door.newState('closed');
  final isLocked = door.newState('locked');

  StateTransition open = door.newStateTransition('open', [isClosed], isOpen);
  StateTransition close = door.newStateTransition('close', [isOpen], isClosed);
  StateTransition lock = door.newStateTransition('lock', [isClosed], isLocked);
  StateTransition unlock =
      door.newStateTransition('unlock', [isLocked], isClosed);

  // Pass the doorwayEmpty flag to the state.
  open.cancelIf((stateChange) => stateChange.payload != true);

  // door.start(isOpen);

  return door;
}
