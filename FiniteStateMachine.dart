// Formally a finite-state machine is a 5-tuple consisting of:
// states: finite set of states (non-empty)
// alphabet: finite set of symbols, called the input alphabet (non-empty)
// transition function: states x alphabet -> state
// initial state (in states)
// final set of states (exit)
class FiniteStateMachine {
  //States
  Set<String> states;
  //Alphabet, what input type is supported (might need heavy parsing?)

  //Transition function, which state can be reached directly with which input

  //Initial state
  String initialState;
  Set<String> finalStates;

  FiniteStateMachine(this.states, this.initialState, this.finalStates);
}
