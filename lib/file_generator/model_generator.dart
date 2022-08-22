import 'dart:io';

import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';

import 'package:mason/mason.dart';

abstract class ModelGenerator {
  factory ModelGenerator(String blocBasePath, VisitedCubit result) {
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
  final String _blocBasePath;
  final VisitedCubit _vCubit;

  CubitModelGenerator(this._blocBasePath, this._vCubit);

  @override
  Future<void> writeModel() async {
    String machineName = _vCubit.name;

    String modelFolder = "gen/models";
    String modelFile = modelFolder + "/${machineName}.dart";

    Set<String> states = _vCubit.states;
    Set<Transition> transitions = _vCubit.transitions;
    String startingState = _vCubit.startingState;

    //TODO: add cubit import (retrieve from AST)

    final brick = Brick.path("bricks/statemachine_model_cubit");
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory("lib/$modelFolder"));

    List<GeneratedFile> generatedFile = await generator.generate(
      target,
      vars: <String, dynamic>{
        'name': machineName,
        'states': states.map((state) => {'state': state}),
        'transitions': transitions.map((t) => {
              'name': t.functionName,
              'fromStates': t.fromStates.map((from) => {'from': from}).toList(),
              'toState': t.toState,
              'conditions': t.conditions.map((c) => {'condition': c}).toList(),
              'inputs': t.inputs.entries
                  .map((e) => {'input': e.key, 'type': e.value})
                  .toList(),
            }),
        'startingState': startingState,
      },
    );
    print(generatedFile.toString());

    // Format the newly written model file
    FileGeneratorHelperFunctions.formatFiles([modelFile]);
  }
}
