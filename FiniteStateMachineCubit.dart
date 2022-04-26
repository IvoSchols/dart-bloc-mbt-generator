import 'FiniteStateMachine.dart';

class FiniteStateMachineCubit extends FiniteStateMachine {
  FiniteStateMachineCubit(
    String name,
    Set<String> states,
    Set<String> events,
    Map<Tuple, String> transitionFunction,
    String initialState,
    Set<String> finalStates,
  ) : super(
          name,
          states,
          events,
          transitionFunction,
          initialState,
          finalStates,
        );
}
