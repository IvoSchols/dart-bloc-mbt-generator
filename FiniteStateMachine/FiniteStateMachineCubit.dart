import 'FiniteStateMachineBase.dart';

class FiniteStateMachineCubit extends FiniteStateMachineBase {
  Map<String, Function(Map<String, dynamic> context)> functions;

  FiniteStateMachineCubit(
      {required String name,
      required Set<State> states,
      required State initialState,
      required Set<State> finalStates,
      required Map<String, dynamic> context,
      required Map<String, Function(Map<String, dynamic> context)> functions})
      : functions = functions,
        super(
            name: name,
            states: states,
            initialState: initialState,
            finalStates: finalStates,
            context: context,
            actions: Map());

  void function(String name) {
    functions[name]!(context)();
  }
}
