import 'dart:io';
import 'dart:convert';

import 'FiniteStateMachineCubit.dart';

// Formally a finite-state machine is a 5-tuple consisting of:
// states: finite set of states (non-empty)
// alphabet: finite set of symbols, called the input alphabet (non-empty)
// transition function: states x alphabet -> state
// initial state (in states)
// final set of states (exit)
class FiniteStateMachine {
  //Name
  final String name;
  //States
  final Set<String> states;
  //Alphabet, events that trigger transitions
  final Set<String> events;
  //Transition function, which state can be reached directly with which input
  Map<Tuple, String>? transitionFunction;
  //Initial state
  final String initialState;
  //Final states
  Set<String> finalStates;

  FiniteStateMachine(this.name, this.states, this.events,
      this.transitionFunction, this.initialState, this.finalStates);

  void export(String path) async {
    Map<String, dynamic> json = {
      "name": name,
      "states": states.toList(),
      "events": events.toList(),
      "transitionFunction": transitionFunction,
      "initialState": initialState,
      "finalStates": finalStates.toList()
    };
    var file = await File(path).writeAsString(jsonEncode(json));
  }

  FiniteStateMachine import(String path) {
    File file = File(path);
    String contents = file.readAsStringSync();

    Map<String, dynamic> json = jsonDecode(contents);

    String name = json["name"];
    Set<String> states = Set.from(json["states"]);
    Set<String> events = Set.from(json["events"]);
    Map<String, dynamic> transitionFunctionString = json["transitionFunction"];
    Map<Tuple, String> transitionFunction =
        transitionFunctionString.map((key, value) {
      key = key.substring(1, key.length - 1);
      List<String> keys = key.split(",");
      Tuple tuple = Tuple(keys[0], keys[1]);
      return MapEntry(tuple, value.toString());
    });

    String initialState = json["initialState"];
    Set<String> finalStates = Set.from(json["finalStates"]);

    if (name.contains("Cubit")) {
      return FiniteStateMachineCubit(
          name, states, events, transitionFunction, initialState, finalStates);
    } else {
      return FiniteStateMachine(
          name, states, events, transitionFunction, initialState, finalStates);
    }
  }
}

class Tuple {
  final dynamic t1;
  final dynamic t2;

  Tuple(this.t1, this.t2);
}
