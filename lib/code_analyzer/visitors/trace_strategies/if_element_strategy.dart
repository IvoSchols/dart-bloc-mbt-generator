import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/trace.dart';

enum _IfType { ifT, elseifT, elseT }

class IfElementStrategy extends SimpleAstVisitor {
  IfElementStrategy(Trace currentTrace, this._ElseElement) {
    _currentTrace = currentTrace.copyWith();
  }

  late final Trace _currentTrace;

  get currentTrace => _currentTrace;

  final CollectionElement?
      _ElseElement; // Used to check if the current if statement is an else statement

  @override
  void visitIfElement(IfElement node) {
    Node newNode = _buildIfNode(node.condition);
    BinaryExpressionTree conditionTree = _currentTrace.conditionTree;

    _IfType ifType = _getIfType(node, _ElseElement);

    switch (ifType) {
      case _IfType.ifT:
        conditionTree.root = newNode;
        break;
      case _IfType.elseifT:
        Node oldRoot = _currentTrace.conditionTree.root!.deepCopy();
        conditionTree.root!.right = newNode;

        // If is variable
        if (!conditionTree.root!.isOperator()) {
          Node temp = oldRoot;
          oldRoot = Node('!');
          oldRoot.left = temp;
        } else if (conditionTree.root!.value != "&&") {
          oldRoot.invertOperator();
        } else {
          oldRoot.right!.invertOperator();
        }
        conditionTree.root = Node(
          "&&",
          left: oldRoot,
          right: newNode,
        );
        break;
      default:
        throw "Statement not supported";
    }
  }

  void visitElseElement(SetOrMapLiteral node) {
    BinaryExpressionTree conditionTree = _currentTrace.conditionTree;
    Node oldRoot = conditionTree.root!.deepCopy();
    oldRoot.right!.invertOperator();
    conditionTree.root = oldRoot;
  }

  Node _buildIfNode(Expression condition) {
    //TODO: add fail condition if not unary or binary expression
    if (condition is BinaryExpression) {
      return _buildBinaryExpressionNode(condition);
    } else {
      if (condition is SimpleStringLiteral) {
        return _buildUnaryExpressionNode(condition.value);
      } else {
        return _buildUnaryExpressionNode(condition.toString());
      }
    }
  }

  Node _buildUnaryExpressionNode(String condition) {
    Node node = Node(condition);
    if (condition[0] == '!') {
      node = Node(condition[0]);
      node.left = _buildUnaryExpressionNode(condition.substring(1));
    }
    return node;
  }

  Node _buildBinaryExpressionNode(BinaryExpression condition) {
    Node node = Node(condition.operator.lexeme);
    node.left = _buildIfNode(condition.leftOperand);
    node.right = _buildIfNode(condition.rightOperand);

    return node;
  }

  _IfType _getIfType(IfElement node, CollectionElement? element) {
    if (element == null) {
      return _IfType.ifT;
    } else if (element is IfElement && node == element) {
      return _IfType.elseifT;
    } else {
      throw "IfType not supported";
    }
  }
}
