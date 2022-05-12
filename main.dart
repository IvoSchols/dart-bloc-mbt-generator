import 'FiniteStateMachine/FiniteStateMachine.dart';
import 'FiniteStateMachine/FiniteStateMachineBase.dart';
import 'FiniteStateMachine/FiniteStateMachineCubit.dart';
import 'PathGenerator/PathGenerator.dart';
import 'PathGenerator/SimplePathGenerator.dart';

void main(List<String> args) {
  State A = State("A");
  State B = State("B");
  State C = State("C");
  A.addTransition("event1", A);
  A.addTransition("event2", B);
  // A.addTransition("event3", C);
  B.addTransition("event1", A);
  B.addTransition("event2", B);
  // B.addTransition("event3", C);
  // C.addTransition("event3", C);
  FiniteStateMachineCubit counterCubit = FiniteStateMachineCubit(
      name: "FiniteStateMachine",
      states: Set.from([A, B]),
      events: (["event1", "event2"]),
      initialState: A,
      finalStates: Set.from([B]));

  PathGenerator pathGenerator = SimplePathGenerator();
  List<Paths> allPaths = pathGenerator.generateAllPaths(counterCubit);
  print(allPaths.toString());
}
