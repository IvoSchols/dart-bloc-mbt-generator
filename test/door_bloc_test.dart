import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:equatable/equatable.dart';
import 'package:test/test.dart';

//Modeled after: https://sparxsystems.com/resources/tutorials/uml2/state-diagram.html
//Hand written tests:
void main() {
  group('door', () {
    late DoorBloc doorBloc;
    setUp(() {
      doorBloc = DoorBloc();
    });
    tearDown(() {
      doorBloc.close();
    });
    group('static', () {
      test('initial state', () {
        expect(doorBloc.state,
            anyOf([DoorState.open(true), DoorState.open(false)]));
      });

      blocTest<DoorBloc, DoorState>('close an open door 1',
          build: () => doorBloc,
          act: (bloc) => bloc.add(DoorStatusChanged(DoorStates.closed, true)),
          expect: () => [DoorState.closed()]);

      blocTest<DoorBloc, DoorState>('close an open door 0',
          build: () => doorBloc,
          act: (bloc) => bloc.add(DoorStatusChanged(DoorStates.closed, false)),
          expect: () => []);

      blocTest<DoorBloc, DoorState>('open an closed door 1',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            bloc.add(DoorStatusChanged(DoorStates.open, true));
          },
          expect: () => [DoorState.closed(), DoorState.open(true)]);

      // When the doorstatuschanged, door.open is false -> fail! intentional bug!!
      blocTest('open an closed door 0',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            doorBloc.add(DoorStatusChanged(DoorStates.open, true));
          },
          expect: () => [DoorState.closed(), DoorState.open(true)]);
      blocTest('lock opened door',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.locked, true));
            doorBloc.add(DoorStatusChanged(DoorStates.locked, false));
          },
          expect: () => []);

      blocTest('unlock opened door',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            doorBloc.add(DoorStatusChanged(DoorStates.closed, false));
          },
          expect: () => [DoorState.closed()]);

      blocTest('lock a closed door 1',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            doorBloc.add(DoorStatusChanged(DoorStates.locked, true));
          },
          expect: () => [DoorState.closed(), DoorState.locked()]);

      blocTest('lock a closed door 0',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            doorBloc.add(DoorStatusChanged(DoorStates.locked, false));
          },
          expect: () => [DoorState.closed(), DoorState.locked()]);

      blocTest('unlock a locked door 1',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            doorBloc.add(DoorStatusChanged(DoorStates.locked, true));
            doorBloc.add(DoorStatusChanged(DoorStates.unlocked, true));
          },
          expect: () =>
              [DoorState.closed(), DoorState.locked(), DoorState.closed()]);
      blocTest('unlock a locked door 0',
          build: () => doorBloc,
          act: (bloc) {
            doorBloc.add(DoorStatusChanged(DoorStates.closed, true));
            doorBloc.add(DoorStatusChanged(DoorStates.locked, true));
            doorBloc.add(DoorStatusChanged(DoorStates.unlocked, true));
          },
          expect: () =>
              [DoorState.closed(), DoorState.locked(), DoorState.closed()]);
    });
  });
}

class DoorBloc extends Bloc<DoorEvent, DoorState> {
  DoorBloc() : super(DoorState.open(true)) {
    on<DoorStatusChanged>(_doorStatusChanged);
    print("hit");
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
