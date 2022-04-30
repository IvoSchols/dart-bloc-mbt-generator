import 'FiniteStateMachine/FiniteStateMachine.dart';
import 'FiniteStateMachine/FiniteStateMachineBase.dart';
import 'FiniteStateMachine/FiniteStateMachineCubit.dart';

void main(List<String> args) {
  FiniteStateMachine finiteStateMachine = FiniteStateMachineBase(
      name: "FiniteStateMachine",
      states: Set.from(["state1", "state2", "state3"]),
      events: Set.from(["event1", "event2", "event3"]),
      transitionFunction: {
        Tuple("state1", "event1"): "state2",
        Tuple("state2", "event2"): "state3",
        Tuple("state3", "event3"): "state1"
      },
      initialState: "state1",
      finalStates: Set.from(["state3"]));

  finiteStateMachine = finiteStateMachine.import("CounterCubit.json");

  FiniteStateMachineCubit counterCubit =
      finiteStateMachine as FiniteStateMachineCubit;
}
