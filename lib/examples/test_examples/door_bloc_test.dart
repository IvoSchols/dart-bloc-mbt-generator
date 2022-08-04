import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/bloc_examples/door/bloc/door_bloc.dart';

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
