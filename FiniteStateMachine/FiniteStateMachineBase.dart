import 'dart:io';
import 'dart:convert';
import 'FiniteStateMachine.dart';
import 'FiniteStateMachineCubit.dart';

// A loose than formal defined finite-state machine is a 5-tuple consisting of:
// states: finite list of states (non-empty)
// alphabet: finite set of symbols, called the input alphabet (non-empty)
// transition function: states x alphabet -> state
// initial state: element of states
// finalStates: states set (element(s) of states)
class FiniteStateMachineBase extends FiniteStateMachine {
  //Name
  String name;
  //States
  final Set<State> states;
  //Alphabet, events that trigger transitions
  final List<String> events;
  //Transition function, which state can be reached directly with which input
  Map<Tuple, String>? transitionFunction;
  //Initial state
  final State initialState;
  //Final states
  Set<State> finalStates;

  FiniteStateMachineBase(
      {required this.name,
      required this.states,
      required this.events,
      required this.transitionFunction,
      required this.initialState,
      required this.finalStates});

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

    Map<Tuple, String> transitionFunction =
        (json["transitionFunction"] as Map).map((key, value) {
      key = key.substring(1, key.length - 1);
      List<String> keys = key.split(",");
      Tuple tuple = Tuple(keys[0], keys[1]);
      return MapEntry(tuple, value.toString());
    });

    FiniteStateMachineBase finiteStateMachineBase = FiniteStateMachineBase(
        name: json["name"],
        states: json["states"].map<State>((e) => State(e)).toSet(),
        events: List.from(json["events"]),
        transitionFunction: transitionFunction,
        initialState: State(json["initialState"]),
        finalStates: json["finalStates"].map<State>((e) => State(e)).toSet());

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

  State(this.name);
}
