import 'package:simple_state_machine/state_machine.dart';

// Construct a statemachine with two states (A, B) and one transition (A->B)
StateMachine constructVendingMachineStateMachine() {
  final statemachine = StateMachine('vending_machine');

  final initial = statemachine.newState('initial');
  final inProgress = statemachine.newState('inProgress');
  final loaded = statemachine.newState('loaded');
  final success = statemachine.newState('success');
  final failure = statemachine.newState('failure');

  // ignore: unused_local_variable
  Transition addCoin =
      statemachine.newTransition('addCoin', {initial, inProgress}, inProgress,
          conditions: {
            'inputTypes': ['int'],
            'conditionTree': {
              'type': 'and',
              'children': [
                {
                  'type': 'or',
                  'children': [
                    {'type': 'is', 'value': 'failure'},
                    {'type': '>', 'value': 1},
                    {'type': '>=', 'value': 2}
                  ]
                },
                {'type': 'is', 'value': 'inProgress'}
              ]
            }
          });
  statemachine.newTransition(
    'addCoin',
    {inProgress},
    loaded,
  );
  statemachine.newTransition(
    'buy',
    {loaded},
    success,
  );
  statemachine.newTransition(
    'failure',
    {inProgress, loaded},
    failure,
  );
  statemachine.newTransition(
    'reset',
    {inProgress, success, failure},
    initial,
  );

  statemachine.start(initial);

  return statemachine;
}
