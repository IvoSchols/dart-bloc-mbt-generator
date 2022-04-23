// Formally a finite-state machine is a 5-tuple consisting of:
// states: finite set of states (non-empty)
// alphabet: finite set of symbols, called the input alphabet (non-empty)
// transition function: states x alphabet -> state
// initial state (in states)
// final set of states (exit)
class FiniteStateMachine {
  //Name
  String name;
  //States
  Set<dynamic> states;
  //Alphabet, events that trigger transitions
  Set<dynamic> events;
  //Initial state
  dynamic initialState;
  //Final states
  Set<String> finalStates;
  //Transition function, which state can be reached directly with which input
  Map<Tuple, dynamic> transitionFunction;

  FiniteStateMachine(this.name, this.states, this.events, this.initialState,
      this.finalStates, this.transitionFunction);
}

class Tuple {
  dynamic t1;
  dynamic t2;
}
