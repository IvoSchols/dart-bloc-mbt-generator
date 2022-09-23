import 'dart:collection';

import 'package:binary_expression_tree/binary_expression_tree.dart';

class Trace {
  final String functionName;
  late Set<String> illegalFromStates;
  late String toState;
  final BinaryExpressionTree conditionTree;
  final LinkedHashMap<String, String> inputTypes;

  Trace(
      {required this.functionName,
      required this.conditionTree,
      required this.inputTypes,
      illegalFromStates,
      toState}) {
    this.illegalFromStates = illegalFromStates ?? {};
    this.toState = toState ?? "";
  }

  void setInputTypes(LinkedHashMap<String, String> inputTypes) {
    for (String element in this.inputTypes.keys) {
      assert(!inputTypes.containsKey(element), "Input name already exists");
    }
    this.inputTypes.addAll(inputTypes);
  }

  // Is a deep copy of binary expression tree needed?
  Trace copyWith({
    String? functionName,
    Set<String>? illegalFromStates,
    String? toState,
    BinaryExpressionTree? conditionTree,
    LinkedHashMap<String, String>? inputTypes,
  }) {
    return Trace(
      functionName: functionName ?? this.functionName,
      illegalFromStates: illegalFromStates ?? this.illegalFromStates,
      toState: toState ?? this.toState,
      conditionTree: conditionTree ?? this.conditionTree.copy(),
      inputTypes: inputTypes ?? this.inputTypes,
    );
  }
}
