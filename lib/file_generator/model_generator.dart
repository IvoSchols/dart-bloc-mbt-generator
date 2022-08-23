import 'dart:io';

import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';
import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';
import 'package:dart_bloc_mbt_generator/file_generator/templates/state_machine_template.dart';

abstract class ModelGenerator {
  //TODO; figure out what this is
  factory ModelGenerator(String blocBasePath, VisitedCubit result) {
    if (blocBasePath.contains("cubit") && blocBasePath.contains("bloc")) {
      throw Exception(
          "Cannot determine type: bloc and cubit are not allowed in the same path");
    } else if (blocBasePath.contains("cubit")) {
      return CubitModelGenerator(blocBasePath);
      // } else if (blocBase is Bloc) {
      //   throw Exception("Unimplemented bloc type");
// return BlocGenerator(blocBase as Bloc<dynamic, dynamic>, machine);
    } else {
      throw Exception("Unknown bloc type");
    }
  }

  void writeModel(VisitedCubit vCubit);
}

class CubitModelGenerator implements ModelGenerator {
  final String _blocBasePath;

  CubitModelGenerator(this._blocBasePath);

  @override
  void writeModel(VisitedCubit vCubit) {
    String machineName = vCubit.name;

    String modelFolder = "lib/gen/models";
    String modelFile = "$modelFolder/$machineName.dart";

    //TODO: add cubit import (retrieve from AST)

    String stateMachineStringified = stateMachineTemplate(vCubit);

    // Write string to file relative to the current directory
    File file = File(modelFile);
    file.createSync(recursive: true);
    file.writeAsStringSync(stateMachineStringified);

    // File(modelFile).writeAsStringSync(stateMachineStringified);

    // print(generatedFile.toString());

    String dirPath = '${Directory.current.path}/$modelFile';

    // Format the newly written model file
    //TODO: not working
    FileGeneratorHelperFunctions.formatFiles([dirPath]);
  }
}
