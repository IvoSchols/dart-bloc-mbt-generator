import 'package:bloc/bloc.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'dart:io';
import 'package:mason/mason.dart';

abstract class TestGenerator {
  factory TestGenerator(BlocBase blocBase, StateMachine machine) {
    switch (blocBase.runtimeType) {
      case Cubit:
      case Bloc:
        return CubitGenerator(blocBase as Cubit<dynamic>, machine);
        return BlocGenerator(blocBase as Bloc<dynamic, dynamic>, machine);
      default:
        throw Exception("Unknown bloc type");
    }
  }

  Future<void> writeTests(List<Paths> paths);
}

class CubitGenerator implements TestGenerator {
  Cubit<dynamic> _cubit;
  StateMachine _machine;

  CubitGenerator(this._cubit, this._machine);

  @override
  Future<void> writeTests(List<Paths> paths) async {
    String machineName = _machine.name;
    String testFile = "test/${machineName}_test.dart";
    // TODO: retrieve cubit from AST
    String cubitClassName = _cubit.runtimeType.toString();
    String cubitObjectName = cubitClassName;
    cubitClassName[0].toLowerCase();

    //TODO: add cubit import (retrieve from AST)

    // final brick = Brick.git(
    //   const GitPath(
    //     'https://github.com/felangel/mason.git',
    //     path: 'bricks/greeting',
    //   ),
    // );
    // final generator = await MasonGenerator.fromBrick(brick);
    // final target = DirectoryGeneratorTarget(Directory.current);
    // await generator.generate(target, vars: <String, dynamic>{'name': 'Dash'});

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

// class BlocGenerator implements TestGenerator {
//   Bloc _bloc;
//   StateMachine _machine;

//   BlocGenerator(this._bloc, this._machine);

//   void test(List<Paths> paths) {}
// }
