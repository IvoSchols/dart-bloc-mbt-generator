// Based of: Path-Oriented Test Data Generation Using Symbolic Execution and Constraint Solving Techniques
import 'dart:collection';

import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:collection/collection.dart';

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
  final List<String> _operators = ['&&', '||', '+', '-', '*', '/'];

  @override
  List<Path> generatePaths(StateMachine stateMachine) {
    return [dfs(stateMachine)];
  }

  @override
  List<Path> generatePathsTo(StateMachine machine, State toState) {
    // TODO: implement generatePathsTo
    throw UnimplementedError();
  }

  Path dfs(StateMachine machine, {int maxDepth = 5}) {
    List<Transition> curPath = [];
    Map<String, String> pathInput =
        {}; // Map of input data for the current path (Variable: Value)
    State curState = machine.current;

    for (int depth = 0; depth < maxDepth; depth++) {
      // Select a transition tr which leaves CurState and whose predicate can be satisfied under pathCond
      // Call Z3 to check for satisfiability
      Transition? tr = curState.transitions.firstWhereOrNull(
          (t) => t.to != curState && _satisfiableWith(curPath, t));

      if (tr == null) {
        // If the transition tr does not exist
        if (curState == machine.initial) {
          // If CurState is s0
          break; // Failure
        } else {
          // Backtrack and modify CurState, pathCond and CurPath
          // pathCond.removeLast();
          curPath.removeLast();
          curState = curPath.last.to;
        }
      } else {
        // Add tr to the end of CurPath
        curPath.add(tr);
        // Add tr’s predicate to pathCond
        pathInput = _solve(curPath);
        // Perform tr’s action
        // tr.action(); -> implement in statemachine?

        // Change CurState to tr’s next state
        curState = tr.to;
      }
    }
    // Solve the constraints and output the variables’ values
    Path solvedPath = Path(pathInput, curPath);

    return solvedPath;
  }

// Check if any input exists that satisfies the path condition
// Return true if path is satisfiable, false otherwise
// Source: https://www.101computing.net/reverse-polish-notation/
  bool _satisfiableWith(List<Transition> path, Transition tr) {
    List<Transition> newPath = List.from(path);
    newPath.add(tr);

    return _satisfiable(newPath);
  }

  bool _satisfiable(List<Transition> path) {
// Iterate over all conditions in the path and check if they are satisfiable
    // If any condition is not satisfiable, return false
    // If all conditions are satisfiable, return true
    AST ast = AST(_z3.native);
    var context = ast.context;
    var native = _z3.native;
    var s = Solver(native, context);

    _buildSolverTree(s, ast, path);

    String sResult = s.check();
    s.delSolver();
    return (sResult == "true");
  }

  Map<String, String> _solve(List<Transition> path) {
    AST ast = AST(_z3.native);
    var context = ast.context;
    var native = _z3.native;
    var s = Solver(native, context);
    _buildSolverTree(s, ast, path);
    String sResult = s.model();
    s.delSolver();

    return _modelToMap(sResult);
  }

  void _buildSolverTree(Solver s, AST ast, List<Transition> path) {
    ListQueue<dynamic> operands = ListQueue<dynamic>();

    //Solve the path conditions
    for (Transition t in path) {
      //Check if the transition has a condition
      if (t.conditions == null || t.conditions!.root == null) continue;
      //Translate the transition condition into a Z3 expression
      t.conditions!.callFunctionPostOrder(t.conditions!.root, (Node node) {
        String condition = node.value;

        //Check if the condition is an operator
        if (_operators.contains(condition)) {
          dynamic left = operands.removeLast();
          dynamic right = operands.removeLast();
          dynamic result = _combineAst(ast, condition, left, right);
          operands.add(result);
        } else {
          //The condition is an operand
          operands.add(_stringToAst(ast, condition, t.inputTypes));
        }
      });
    }

    for (var o in operands) {
      s.add(o);
    }
  }

  dynamic _stringToAst(
      AST ast, String variable, Map<String, String> inputTypes) {
    if (!inputTypes.containsKey(variable)) {
      throw Exception('Variable $variable not found in inputTypes');
    }
    String type = inputTypes[variable]!;

    if (type == 'bool') {
      return ast.mkBoolVar(variable);
    } else {
      throw Exception('Unsupported type $type');
    }
  }

  dynamic _combineAst(AST ast, String operator, dynamic left, dynamic right) {
    if (operator == "&&") {
      return ast.and([left, right]);
    } else if (operator == "||") {
      return ast.or([left, right]);
    } else if (operator == "+") {
      return ast.add([left, right]);
    } else if (operator == "-") {
      throw UnimplementedError();
      // return ast.sub([left, right]);
    } else if (operator == "*") {
      return ast.mul([left, right]);
    } else if (operator == "/") {
      throw UnimplementedError();
      // return ast.div(left, right);
    }
  }

  Map<String, String> _modelToMap(String model) {
    Map<String, String> map = {};
    List<String> lines = model.split('\n');
    for (String line in lines) {
      if (line == "") continue;
      List<String> result = line.split(' -> ');
      map[result.first] = result.last;
    }
    return map;
  }
}
