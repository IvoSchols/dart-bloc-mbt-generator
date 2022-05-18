import 'FiniteStateMachine/FiniteStateMachine.dart';
import 'FiniteStateMachine/FiniteStateMachineBase.dart';
import 'FiniteStateMachine/FiniteStateMachineCubit.dart';
import 'PathGenerator/PathGenerator.dart';
import 'PathGenerator/SimplePathGenerator.dart';

void main(List<String> args) {
  State A = State("A");
  // State B = State("B");
  // State C = State("C");
  A.addTransition("event1", A);
  // A.addTransition("event2", B);
  // A.addTransition("event3", C);
  // B.addTransition("event1", A);
  // B.addTransition("event2", B);
  // B.addTransition("event1", C);
  // C.addTransition("event3", C);
  A.entryActions.add("increment");

  Map<String, dynamic> context = {"count": 0};
  Map<String, Function(Map<String, dynamic> context)> functions = {
    "increment": (Map<String, dynamic> context) => () => context["count"]++,
    "decrement": (Map<String, dynamic> context) => () => context["count"]--,
  };

  FiniteStateMachineCubit counterCubit = FiniteStateMachineCubit(
    name: "CounterFiniteStateMachine",
    states: Set.from([A]),
    initialState: A,
    finalStates: Set.from([A]),
    context: context,
    functions: functions,
  );

  counterCubit.function("increment");
  counterCubit.function("decrement");
  counterCubit.function("increment");
  print(counterCubit.context["count"]);

  PathGenerator pathGenerator = SimplePathGenerator();
  List<Paths> allPaths = pathGenerator.generateAllPaths(counterCubit);
  print(allPaths.toString());
}
