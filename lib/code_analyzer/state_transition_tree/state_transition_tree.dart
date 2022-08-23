import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/state_transition_tree/state_transition_node.dart';

class StateTransitionTree extends BinaryExpressionTree {
  StateTransitionTree({required Node root}) : super(root: root);

  // Perform a (depth-first traversal)?correct?? of the tree and build a Z3 expression.
  // ConstraintNodeInput solve(ConstraintNode node) {
  //   // return _solve(root, variables);
  // }
}

class ConstraintNodeInput {
  // Set<String> illegalFromStates = {};
  Map<String, String> trueInput;
  Map<String, String> falseInput;

  ConstraintNodeInput({required this.trueInput, required this.falseInput});
}
