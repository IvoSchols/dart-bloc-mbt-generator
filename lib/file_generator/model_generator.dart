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
  // Cubit<dynamic> _cubit;
  String _blocBasePath;
  VisitedCubit _vCubit;

  CubitModelGenerator(this._blocBasePath, this._vCubit);

  @override
  Future<void> writeModel() async {
    String machineName = _vCubit.name;

    String modelFolder = "gen/models";
    String modelFile = modelFolder + "/${machineName}.dart";

    Set<String> states = _vCubit.states;
    Set<Transition> stateTransitions = _vCubit.transitions;
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
        'transitions': stateTransitions.map((st) => {
              // 'transition': st.event,
              'froms': st.fromStates.map((from) => {'from': from}).toList(),
              'to': st.toStates
            }),
        'startingState': startingState,
      },
    );
    print(generatedFile.toString());

    // Format the newly written model file
    FileGeneratorHelperFunctions.formatFiles([modelFile]);
  }
}

// class BlocGenerator implements TestGenerator {
//   Bloc _bloc;
//   StateMachine _machine;

//   BlocGenerator(this._bloc, this._machine);

//   void test(List<Paths> paths) {}
// }