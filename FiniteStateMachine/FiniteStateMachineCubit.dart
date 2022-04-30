import 'FiniteStateMachineBase.dart';

class FiniteStateMachineCubit extends FiniteStateMachineBase {
  FiniteStateMachineCubit(
      {required String name,
      required Set<String> states,
      required Set<String> events,
      required Map<Tuple, String>? transitionFunction,
      required String initialState,
      required Set<String> finalStates})
      : super(
            name: name,
            states: states,
            events: events,
            transitionFunction: transitionFunction,
            initialState: initialState,
            finalStates: finalStates);
}
