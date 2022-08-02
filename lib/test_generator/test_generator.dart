import 'package:bloc/bloc.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'dart:io';

abstract class TestOracle {
  factory TestOracle(BlocBase blocBase, StateMachine machine) {
    switch (blocBase.runtimeType) {
      case Cubit:
        return CubitOracle(blocBase as Cubit<dynamic>, machine);
      case Bloc:
        return BlocOracle(blocBase as Bloc<dynamic, dynamic>, machine);
      default:
        throw Exception("Unknown bloc type");
    }
  }

  void writeTests(List<Paths> paths);
}

class CubitOracle implements TestOracle {
  Cubit<dynamic> _cubit;
  StateMachine _machine;

  CubitOracle(this._cubit, this._machine);

  @override
  void writeTests(List<Paths> paths) {
    String machineName = _machine.name;
    String testFile = "test/${machineName}_test.dart";
    // TODO: retrieve cubit from AST

    var file = File(testFile);
    IOSink sink = file.openWrite();

    // Write imports
    // sink.write("import 'package:bloc/bloc.dart';\n");
    // sink.write("import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';\n");
    // sink.write("import 'package:dart_bloc_mbt_generator/path_generator/simple_path_generator.dart';\n");
    sink.writeln("import 'package:test/test.dart");
    sink.writeln("package:bloc_test/bloc_test.dart");
    //TODO: add cubit import (retrieve from AST)

    // Write main, write group
    sink.writeln("void main() {");
    sink.writeln("group('{$machineName}Cubit', () {
    sink.writeln("CounterBloc counterBloc;") 

    setUp(() {
        counterBloc = CounterBloc();
    });")

    // Close main, close group
    sink.writeln("}");

    for (Paths path in paths) {
      _writeTest(sink, path);
    }

    // Close the IOSink to free system resources.
    sink.close();

    // Format the newly written test file
    Process.run('dart', ['format', testFile]).then((result) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    });
  }

  void _writeTest(IOSink sink, Paths path) {
    String testName = _getTestName(path);
    String testBody = _getTestBody(path);
    print("$testName\n$testBody");
  }
}

class BlocOracle implements TestOracle {
  Bloc _bloc;
  StateMachine _machine;

  BlocOracle(this._bloc, this._machine);

  void test(List<Paths> paths) {}
}
