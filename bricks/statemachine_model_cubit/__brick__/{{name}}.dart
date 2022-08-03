import 'package:state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine construct{{name.pascalCase()}}Statemachine() {
  final statemachine = StateMachine('{{name.snakeCase()}}');

  // Define states
  {{#states}}
    final {{state.camelCase()}} = statemachine.newState('{{state.pascalCase()}}');
  {{/states}}

  // Define transitions
  {{#transitions}}
    StateTransition {{transition.camelCase()}} = statemachine.newStateTransition('{{transition.camelCase()}}', [{{#froms}}{{from.camelCase()}},{{/froms}}], {{to.camelCase()}});
  {{/transitions}}

  // Define starting state
  statemachine.start({{startingState.camelCase()}});

  return statemachine;
}
