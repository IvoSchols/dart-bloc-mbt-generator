// Based of: Path-Oriented Test Data Generation Using Symbolic Execution and Constraint Solving Techniques
import 'dart:collection';

import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_z3/dart_z3.dart';
import 'package:state_machine/state_machine.dart';

import 'path_generator.dart';

class ZhangPathGenerator implements PathGenerator {
/*
void DFS()
{
CurPath = empty;
pathCond = empty;
CurState = s0; // initial state
while (true) {
if CurState is a terminal state {
solve the constraints pathCond and
output the variables’ values;
return;
}
select a transition tr which leaves
CurState and whose predicate can
be satisfied under pathCond;
if the transition tr does not exist {
if CurState is s0
return; // Failure
else backtrack and modify
CurState, pathCond and CurPath;
}
else {
add tr’s predicate to pathCond;
perform tr’s action;
add tr to the end of CurPath;
change CurState to tr’s next state;
}
}
}
*/
// pathCond refers to the path condition, which represents the set of input data
// that can drive the program to the current state along the current path. Besides
// the path condition, we also need to record and update every variable’s value
// (which is a symbolic arithmetic expression)

  final Z3 _z3 = Z3();

  List<dynamic> dfs(StateMachine machine, {int maxDepth = 100}) {
    List<Transition> curPath = [];
    Map<String, String> pathCond =
        {}; // Map of input data for the current path (Variable: Value)
    State curState = machine.current;

    for (int depth = 0; depth < maxDepth; depth++) {
      // Select a transition tr which leaves CurState and whose predicate can be satisfied under pathCond
      // Call Z3 to check for satisfiability
      Transition? tr = curState.transitions.firstWhere(
          (t) => t.to != curState && _satisfiableUnder(curPath),
          orElse: () => null);

      if (tr == null) {
        // If the transition tr does not exist
        if (curState == machine.initial) {
          // If CurState is s0
          break; // Failure
        } else {
          // Backtrack and modify CurState, pathCond and CurPath
          pathCond.removeLast();
          curPath.removeLast();
          curState = curPath.last.to;
        }
      } else {
        // Add tr’s predicate to pathCond
        pathCond.addAll(tr.cancelTests);
        // Perform tr’s action
        // tr.action(); -> implement in statemachine?
        // Add tr to the end of CurPath
        curPath.add(tr);
        // Change CurState to tr’s next state
        curState = tr.to;
      }
    }
    // Solve the constraints and output the variables’ values

    return curPath;
  }

// Check if any input exists that satisfies the path condition
// Return true if path is satisfiable, false otherwise
  bool _satisfiableUnder(List<Transition> path) {
    // Iterate over all conditions in the path and check if they are satisfiable
    // If any condition is not satisfiable, return false
    // If all conditions are satisfiable, return true
    AST ast = AST(_z3.native);

    var context = ast.context;
    var native = _z3.native;
    var s = Solver(native, context);

    // for (Transition tr in path) {
    //   for (String condition in tr.conditions) {
    //     var expr = ast.parse(condition);
    //     s.add(expr);
    //   }
    // }

    // for (var cancelTest in newCancelTests) {
    //   ast.mkBoolVar(name)
    //   ast.and
    //   s.add(ast)
    // }
    String sResult = s.check();
    s.delSolver();
    return (sResult == "true");
  }

  @override
  List<Path> generatePaths(StateMachine stateMachine) {
    return dfs(machine: stateMachine, maxDepth: 100);
  }

  @override
  List<Path> generatePathsTo(StateMachine machine, State toState) {
    // TODO: implement generatePathsTo
    throw UnimplementedError();
  }
}
