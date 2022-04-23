import 'FiniteStateMachine.dart';

class FiniteStateMachineCubit extends FiniteStateMachine {
  FiniteStateMachineCubit(
    String name,
    Set states,
    Set events,
    initialState,
    Set<String> finalStates,
    Map<Tuple, dynamic> transitionFunction,
  ) : super(name, states, events, initialState, finalStates,
            transitionFunction);
}
