import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/listeners/transitions_listener.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/event_listener.dart';

class DirectInvocation extends TransitionsListener implements EventListener {
  @override
  void visitMethodInvocation(MethodInvocation node) {
    // TODO: implement visitMethodInvocation
  }
}
