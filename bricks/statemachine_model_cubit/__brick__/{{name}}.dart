// @dart=2.9
import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:state_machine/state_machine.dart';


// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine construct{{name.pascalCase()}}Statemachine() {
  final statemachine = StateMachine('{{name.snakeCase()}}');

  // Define states
  {{#states}}
    final {{state.camelCase()}} = statemachine.newState('{{state.pascalCase()}}');
  {{/states}}

  // Define transitions and their conditions
  {{#transitions}}
    Transition {{transition.camelCase()}} = statemachine.newStateTransition('{{transition.camelCase()}}', [{{#fromStates}}{{from.camelCase()}},{{/fromStates}}], {{toState.camelCase()}});

    {{#conditions}}
      {{transition.camelCase()}}.cancelIf(())
    {{/conditions}}
  {{/transitions}}

  // Define starting state
  statemachine.start({{startingState.camelCase()}});

  return statemachine;
}
