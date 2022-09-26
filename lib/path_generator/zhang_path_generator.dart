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

  @override
  List<Path> generatePaths(StateMachine stateMachine) {
    return [dfs(stateMachine)];
  }

  @override
  List<Path> generatePathsTo(StateMachine machine, State toState) {
    // TODO: implement generatePathsTo
    throw UnimplementedError();
  }

  Path dfs(StateMachine machine, {int maxDepth = 6}) {
    List<Transition> curPath = [];
    List<Map<String, String>> curPathInputs =
        []; // Map of input data for the current path (Variable: Value)

    for (int depth = 0; depth < maxDepth; depth++) {
      //NAIVE IMPLEMENTATION -> SHOULD USE SCOREBOARD
      // Select a transition tr, visits not current, visits an unvisted state and
      // whose predicate can be satisfied under pathCond
      // Call Z3 to check for satisfiability
      Transition? tr = _selectTransition(machine, curPath);

      if (tr == null) {
        // If the transition tr does not exist
        if (machine.current == machine.initial) {
          // If CurState is s0
          break; // Failure
        } else {
          // Backtrack and modify CurState, pathCond and CurPath
          curPath.removeLast();
          curPathInputs.removeLast();

          if (!curPath.isNotEmpty) {
            curPath.last.execute(); // Backtrack
          } else {
            machine.start(); // Reset to initial state
          }
        }
      } else if (tr.execute()) {
        // Change CurState to tr’s next state

        curPath.add(tr); // Add tr to the end of CurPath

        curPathInputs.add(_solve(tr)); // Add tr’s predicate to pathCond
      }
    }
    // Solve the constraints and output the variables’ values
    Path solvedPath = Path(curPathInputs, curPath);

    return solvedPath;
  }

  bool _satisfiable(Transition t) {
// Iterate over all conditions in the path and check if they are satisfiable
    // If any condition is not satisfiable, return false
    // If all conditions are satisfiable, return true
    AST ast = AST(_z3.native);
    var context = ast.context;
    var native = _z3.native;
    var s = Solver(native, context);

    _buildSolverTree(s, ast, t);

    String sResult = s.check();
    s.reset();
    return (sResult == "true");
  }

  Map<String, String> _solve(Transition t) {
    // Solve all conditions in the path and return the input data
    AST ast = AST(_z3.native);
    var context = ast.context;
    var native = _z3.native;
    var s = Solver(native, context);
    _buildSolverTree(s, ast, t);
    String sResult = s.model();
    s.reset();

    return _modelToMap(sResult);
  }

  void _buildSolverTree(Solver s, AST ast, Transition t) {
    ListQueue<dynamic> operands = ListQueue<dynamic>();
    // Store variables and their Z3 expressions
    Map<String, dynamic> variables = {};

    //Solve the path conditions

    //Check if the transition has a condition
    if (t.conditions?['conditionTree'] == null) {
      return;
    }
    //Translate the transition condition into a Z3 expression
    BinaryExpressionTree conditionTree = t.conditions!['conditionTree'];
    conditionTree.callFunctionPostOrder(conditionTree.root, (Node node) {
      String nodeValue = node.value;

      //Check if the condition is an operator
      if (node.isOperator()) {
        //PROBABLY GOING TO BOMB WHEN ! is hit
        //WHAT IS HAPPENING HERE? -> ORDER OF OPERANDS IS WRONG -> NEED TO REVERSE -> BUT PRODUCES WRONG RESULT
        dynamic right = nodeValue == '!' ? null : operands.removeLast();
        dynamic left = operands.removeLast();
        //swap with right if left is null
        if (left == null) {
          left = right;
          right = null;
        }

        dynamic result = _combineAst(ast, nodeValue, left, right);
        operands.add(result);
        s.add(result);
        //TODO: check if operands can be added to solver here
      } else {
        //The condition is an operand
        //Check if the operand is a variable
        if (t.conditions!['inputTypes'][nodeValue] != null) {
          dynamic operand;
          // Check if the variable has already been added to the solver
          if (variables[nodeValue] == null) {
            //Add the variable to the solver
            operand = _stringToAstVariable(
                ast, nodeValue, t.conditions!['inputTypes'][nodeValue]);
            variables[nodeValue] = operand;
          } else {
            operand = variables[nodeValue];
          }
          operands.add(operand);
          //If not assume operand is a constant (String) SMELLY!
        } else {
          // is a constant
          operands.add(_stringToAstConstant(ast, node.value));
        }
      }
    });
    // for (dynamic operand in operands) {
    //   s.add(operand);
    // }
  }

  dynamic _stringToAstVariable(AST ast, String variable, String? type) {
    if (type == null) {
      throw Exception('Variable $variable not found in inputTypes');
    }

    switch (type) {
      case 'int':
        return ast.mkIntVar(variable);
      case 'bool':
        return ast.mkBoolVar(variable);
      case 'String':
        return ast.mkStringVar(variable);
      default:
        throw Exception('Type $type not supported');
    }
  }

  //Extremely smelly way of discerning types! -> should probably keep map of types
  dynamic _stringToAstConstant(AST ast, String constant) {
    if (_isNumeric(constant.toString())) {
      return ast.mkInt(int.tryParse(constant.toString())!);
    }
    return ast.mkStringConst(constant);
  }

  dynamic _combineAst(AST ast, String operator, dynamic left, dynamic right) {
    switch (operator) {
      case '&&':
        return ast.and([left, right]);
      case '||':
        return ast.or([left, right]);
      case '==':
        return ast.eq(left, right);
      case '!=':
        return ast.neq(left, right);
      case '>=':
        return ast.ge(left, right);
      case '<=':
        return ast.le(left, right);
      case '>':
        return ast.gt(left, right);
      case '<':
        return ast.lt(left, right);
      case '!':
        return ast.not(left);
      case '+':
        return ast.add([left, right]);
      case '-':
        // return ast.sub([left, right]);
        throw Exception('Unsupported operator $operator');
      case '*':
        return ast.mul([left, right]);
      default:
        throw Exception('Unsupported operator $operator');
    }
  }

  Map<String, String> _modelToMap(String model) {
    Map<String, String> map = {};
    List<String> lines = model.split('\n');
    for (String line in lines) {
      if (line == "") continue;
      List<String> result = line.split(' -> ');
      if (result[1][0] == '(') {
        result[1] = result[1].substring(1, result[1].length - 1);
      }
      map[result.first] = result.last;
    }
    return map;
  }

  // Select next transition, either not visited or least visited
  Transition? _selectTransition(
    StateMachine machine,
    List<Transition> curPath,
  ) {
    Transition? transition;

    // Check if transition is not current, not visited and can be satisfied
    transition = machine.current.transitions.firstWhereOrNull((t) =>
        t.to != machine.current && !curPath.contains(t) && _satisfiable(t));

    // If no transition is found, check if transition exists that is not current,
    // least visited and can be satisfied
    if (transition == null) {
      // Count number of times each transition is visited using groupFoldBy
      Map<Transition, int> transitionCount =
          curPath.groupFoldBy((t) => t, (previous, _) => (previous ?? 0) + 1);
      // Delete current state from transitionCount
      transitionCount.remove(machine.current);
      // Sort transitions by number of times visited
      List<Transition> sortedTransitions = transitionCount.keys.toList()
        ..sort((a, b) => transitionCount[a]!.compareTo(transitionCount[b]!));
      // Get least visited transition that is not current and can be satisfied
      transition = sortedTransitions.firstWhereOrNull((t) => _satisfiable(t));
    }
    return transition;
  }

  //https://stackoverflow.com/questions/24085385/checking-if-string-is-numeric-in-dart
  _isNumeric(string) => num.tryParse(string) != null;
}
