import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';

import 'package:mason/mason.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

abstract class TestGenerator {
  factory TestGenerator(String blocBasePath, StateMachine machine) {
    if (blocBasePath.contains("cubit") && blocBasePath.contains("bloc")) {
      throw Exception(
          "Cannot determine type: bloc and cubit are not allowed in the same path");
    } else if (blocBasePath.contains("cubit")) {
      return CubitGenerator(blocBasePath, machine);
      // } else if (blocBase is Bloc) {
      //   throw Exception("Unimplemented bloc type");
// return BlocGenerator(blocBase as Bloc<dynamic, dynamic>, machine);
    } else {
      throw Exception("Unknown bloc type");
    }
  }

  Future<void> writeTests(List<Paths> paths);
}

class CubitGenerator implements TestGenerator {
  // Cubit<dynamic> _cubit;
  String _blocBasePath;
  StateMachine _machine;

  CubitGenerator(this._blocBasePath, this._machine);

  @override
  Future<void> writeTests(List<Paths> paths) async {
    String machineName = _machine.name;
    String testFile = "test/${machineName}.dart";
    // TODO: retrieve cubit from AST
    String cubitClassName = _machine.runtimeType.toString();
    String cubitObjectName = cubitClassName;
    cubitClassName.replaceRange(0, 0, cubitClassName[0].toLowerCase());

    //TODO: add cubit import (retrieve from AST)

    final brick = Brick.path("bricks/cubit_test");
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory("test"));
    List<GeneratedFile> generatedFile = await generator.generate(
      target,
      vars: <String, dynamic>{
        'name': 'simple ab test',
        'imports': [
          {'import': 'package:dart_bloc_mbt_generator/$_blocBasePath'}
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
    FileGeneratorHelperFunctions.formatFiles([testFile]);
  }
}

// class BlocGenerator implements TestGenerator {
//   Bloc _bloc;
//   StateMachine _machine;

//   BlocGenerator(this._bloc, this._machine);

//   void test(List<Paths> paths) {}
// }