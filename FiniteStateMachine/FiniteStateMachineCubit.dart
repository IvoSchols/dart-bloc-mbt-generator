import 'FiniteStateMachineBase.dart';

class FiniteStateMachineCubit extends FiniteStateMachineBase {
  FiniteStateMachineCubit(
      {required String name,
      required Set<State> states,
      required List<String> events,
      required Map<Tuple, String>? transitionFunction,
      required State initialState,
      required Set<State> finalStates})
      : super(
            name: name,
            states: states,
            events: events,
            transitionFunction: transitionFunction,
            initialState: initialState,
            finalStates: finalStates);
}
