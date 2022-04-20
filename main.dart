import 'dart:io';

import 'CubitParser.dart';
import 'FiniteStateMachine.dart';
import 'FiniteStateMachineParser.dart';

//NOTE: obviously only has support for one bloc in a file, but it's a good start
FiniteStateMachine parseFile() {
  File file = new File('examples/counter/counter_cubit.dart');
  FiniteStateMachineParser finiteStateMachineParser = CubitParser();

  List<String> lines = file.readAsLinesSync();
  for (String line in lines) {
    if (line.contains("extends Cubit")) {
      finiteStateMachineParser = CubitParser();
      break;
      //TODO: Skip the rest of the file?
    } else if (line.contains("extends Bloc")) {
      print("no match");
      //print(line);
    }
  }
  return finiteStateMachineParser.parse(lines);
  throw UnimplementedError();
}

void main(List<String> args) {
  FiniteStateMachine finiteStateMachine = parseFile();
}
