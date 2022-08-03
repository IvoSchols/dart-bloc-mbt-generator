import 'package:bloc/bloc.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'dart:io';
import 'package:mason/mason.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

abstract class TestGenerator {
  factory TestGenerator(String blocBasePath, StateMachine machine) {
    dynamic result = Analyzer.analyzeSingleFile(blocBasePath);
    if (result.type == "cubit") {
      return CubitGenerator(result);
      // } else if (blocBase is Bloc) {
      //   throw Exception("Unimplemented bloc type");
// return BlocGenerator(blocBase as Bloc<dynamic, dynamic>, machine);
    } else {
      throw Exception("Unknown bloc type");
    }
  }

  Future<void> writeTests(List<Paths> paths);
}

class CubitGenerator
    with TestGeneratorHelperFunctions
    implements TestGenerator {
  // Cubit<dynamic> _cubit;
  // StateMachine _machine;
  dynamic _result;

  CubitGenerator(this._result);

  @override
  Future<void> writeTests(List<Paths> paths) async {
    String machineName = _result.name;
    String testFile = "test/${machineName}/${machineName}_test.dart";
    // TODO: retrieve cubit from AST
    String cubitClassName = _result.runtimeType.toString();
    String cubitObjectName = cubitClassName;
    cubitClassName.replaceRange(0, 0, cubitClassName[0].toLowerCase());

    //TODO: add cubit import (retrieve from AST)

    final brick = Brick.path("bricks/cubit_test");
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory("test"));
    List<GeneratedFile> generatedFile = await generator.generate(
      target,
      vars: <String, dynamic>{
        'name': 'simple ab',
        'imports': [
          {
            'import':
                'package:dart_bloc_mbt_generator/examples/cubit_examples/simpleAB/cubit/simple_ab_cubit.dart'
          }
        ],
        'cubit': 'SimpleAbCubit',
        'tests': [
          {
            'stateClass': 'SimpleAbState',
            'functions': [
              {
                'function': 'cubit.goToB()',
              }
            ],
            'states': [
              {
                'state': 'SimpleB()',
              }
            ],
          },
          {
            'stateClass': 'SimpleAbState',
            'functions': [
              {
                'function': 'cubit.goToB()',
              },
              {
                'function': 'cubit.goToA()',
              }
            ],
            'states': [
              {
                'state': 'SimpleB()',
              },
              {
                'state': 'SimpleA()',
              }
            ],
          },
        ],
      },
    );
    print(generatedFile.toString());

    // Format the newly written test file
    _formatFiles([testFile]);
  }
}

// class BlocGenerator implements TestGenerator {
//   Bloc _bloc;
//   StateMachine _machine;

//   BlocGenerator(this._bloc, this._machine);

//   void test(List<Paths> paths) {}
// }

class TestGeneratorHelperFunctions {
  void _formatFile(String path) {
    Process.run('dart', ['format', path]).then((result) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    });
  }

  void _formatFiles(List<String> paths) {
    for (String path in paths) {
      _formatFile(path);
    }
  }
}
