import 'package:binary_expression_tree/binary_expression_tree.dart';

class ConstraintNode extends Node {
  Set<String> illegalFromStates = {};

  ConstraintNode(super.value);
}

class FunctionNode extends Node {
  Map<String, String> parameters = {};
  FunctionNode(super.value);
}
