import 'FiniteStateMachine.dart';

class FiniteStateMachineCubit extends FiniteStateMachine {
  FiniteStateMachineCubit(
      Set<String> states, String initialState, Set<String> finalStates)
      : super(states, initialState, finalStates);
}
