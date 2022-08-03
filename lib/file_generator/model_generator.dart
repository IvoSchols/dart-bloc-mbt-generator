import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/visitor/cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';

import 'package:mason/mason.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

abstract class ModelGenerator {
  factory ModelGenerator(String blocBasePath, dynamic result) {
    if (blocBasePath.contains("cubit") && blocBasePath.contains("bloc")) {
      throw Exception(
          "Cannot determine type: bloc and cubit are not allowed in the same path");
    } else if (blocBasePath.contains("cubit")) {
      return CubitModelGenerator(blocBasePath, result);
      // } else if (blocBase is Bloc) {
      //   throw Exception("Unimplemented bloc type");
// return BlocGenerator(blocBase as Bloc<dynamic, dynamic>, machine);
    } else {
      throw Exception("Unknown bloc type");
    }
  }

  Future<void> writeModel();
}

class CubitModelGenerator implements ModelGenerator {
  // Cubit<dynamic> _cubit;
  String _blocBasePath;
  dynamic _result;

  CubitModelGenerator(this._blocBasePath, this._result);

  @override
  Future<void> writeModel() async {
    String machineName = _result["name"];
    Set<String> states = _result["states"];
    List<CubitStateTransition> stateTransitions = _result["transitions"];
    String startingState = _result["startingState"];

    //TODO: add cubit import (retrieve from AST)

    final brick = Brick.path("bricks/statemachine_model_cubit");
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory("examplair"));
    List<GeneratedFile> generatedFile = await generator.generate(
      target,
      vars: <String, dynamic>{
        'name': machineName,
        'states': states.map((state) => {'state': state}).toList(),
        'transitions': stateTransitions.map((st) =>
            {'transition': st.event, 'from': st.fromState, 'to': st.toState}),
        'startingState': startingState,
      },
    );
    print(generatedFile.toString());

    // Format the newly written test file
    // FileGeneratorHelperFunctions.formatFiles([testFile]);
  }
}

// class BlocGenerator implements TestGenerator {
//   Bloc _bloc;
//   StateMachine _machine;

//   BlocGenerator(this._bloc, this._machine);

//   void test(List<Paths> paths) {}
// }