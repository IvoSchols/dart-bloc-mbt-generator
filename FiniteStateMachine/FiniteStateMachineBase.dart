import 'dart:io';
import 'dart:convert';
import 'FiniteStateMachine.dart';
import 'FiniteStateMachineCubit.dart';

// A loose than formal defined finite-state machine is a 5-tuple consisting of:
// states: finite list of states (non-empty)
// alphabet: finite set of symbols, called the input alphabet (non-empty)
// transition function: states x alphabet -> state (implictly defined in states)
// initial state: element of states
// finalStates: states set (element(s) of states)
class FiniteStateMachineBase extends FiniteStateMachine {
  //Name
  String name;
  //States
  final Set<State> states;
  //Alphabet, events that trigger transitions
  final List<String> events;
  //Initial state
  final State initialState;
  //Final states
  Set<State> finalStates;

  FiniteStateMachineBase(
      {required this.name,
      required this.states,
      required this.events,
      required this.initialState,
      required this.finalStates}) {
    if (states.isEmpty) {
      throw Exception("States cannot be empty");
    }
    if (events.isEmpty) {
      throw Exception("Events cannot be empty");
    }
    // If any state contains an event that is not in events throw an exception
    states.forEach((state) {
      state.transitions.forEach((event, nextState) {
        if (!events.contains(event)) {
          throw Exception("Event $event not found in events");
        }
      });
    });

    if (!states.any((state) => state == initialState)) {
      throw Exception(
          "Initial state $initialState is not in the set of states");
    }
    if (finalStates.every((State state) => !states.contains(state))) {
      throw Exception("Final states must be in states");
    }
  }

  //TODO: write when finished
  void export(String path) async {
    Map<String, dynamic> json = {
      "name": name,
      "states": states,
      "events": events,
      "initialState": initialState,
      "finalStates": finalStates.toList()
    };
    var file = await File(path).writeAsString(jsonEncode(json));
  }

  //TODO: write when finished
  FiniteStateMachine import(String path) {
    File file = File(path);
    String contents = file.readAsStringSync();

    Map<String, dynamic> json = jsonDecode(contents);

    Map<Tuple, String> transitionFunction =
        (json["transitionFunction"] as Map).map((key, value) {
      key = key.substring(1, key.length - 1);
      List<String> keys = key.split(",");
      Tuple tuple = Tuple(keys[0], keys[1]);
      return MapEntry(tuple, value.toString());
    });

    FiniteStateMachineBase finiteStateMachineBase = FiniteStateMachineBase(
        name: json["name"],
        states: json["states"].map<State>((e) {
          State foo = State(e["name"]);
          // foo.addTransition(event, state)
        }),
        events: List.from(json["events"]),
        initialState: json["initialState"],
        finalStates: json["finalStates"].map<State>((e) => State(e["name"])));

    if (name.contains("Cubit")) {
      return finiteStateMachineBase as FiniteStateMachineCubit;
    }
    return finiteStateMachineBase;
  }
}

class Tuple {
  final dynamic t1;
  final dynamic t2;

  Tuple(this.t1, this.t2);
}

class State {
  final String name;

  Map<String, State> transitions = Map();

  State(this.name);

  addTransition(String event, State state) {
    //Check if transition is already defined
    if (transitions[event] != null) return;
    transitions[event] = state;
  }
}
