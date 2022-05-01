import 'FiniteStateMachine/FiniteStateMachine.dart';
import 'FiniteStateMachine/FiniteStateMachineBase.dart';
import 'FiniteStateMachine/FiniteStateMachineCubit.dart';

void main(List<String> args) {
  FiniteStateMachine finiteStateMachine = FiniteStateMachineBase(
      name: "FiniteStateMachine",
      states: Set.from([State("Aiee"), State("B"), State("C")]),
      events: (["event1", "event2", "event3"]),
      transitionFunction: {
        Tuple("state1", "event1"): "state2",
        Tuple("state2", "event2"): "state3",
        Tuple("state3", "event3"): "state1"
      },
      initialState: State("state1"),
      finalStates: Set.from([State("state3")]));

  finiteStateMachine = finiteStateMachine.import("CounterCubit.json");

  FiniteStateMachineCubit counterCubit =
      finiteStateMachine as FiniteStateMachineCubit;
}
