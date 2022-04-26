import 'FiniteStateMachine.dart';
import 'FiniteStateMachineCubit.dart';

void main(List<String> args) {
  FiniteStateMachine finiteStateMachine = FiniteStateMachineCubit(
    "FiniteStateMachineCubit",
    Set.from(["initialState", "state1", "state2"]),
    Set.from(["event1", "event2"]),
    Map.fromIterable(
      [
        Tuple("initialState", "event1"),
        Tuple("state1", "event2"),
        Tuple("state2", "event1"),
      ],
      key: (e) => Tuple(e.t1, e.t2),
      value: (e) => "state1",
    ),
    "initialState",
    Set.from(["state1"]),
  );
  finiteStateMachine = finiteStateMachine.import("CounterCubit.json");

  FiniteStateMachineCubit counterCubit =
      finiteStateMachine as FiniteStateMachineCubit;
}
