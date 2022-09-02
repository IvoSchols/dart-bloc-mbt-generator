import 'dart:io';

import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';
import 'package:dart_bloc_mbt_generator/file_generator/templates/state_machine_template.dart';
import 'package:state_machine/state_machine.dart';

class StateMachineModelGenerator {
  final String _blocBasePath;

  StateMachineModelGenerator(this._blocBasePath);

  @override
  void writeModel(StateMachine stateMachine) {
    String machineName = stateMachine.name;

    String modelFolder = "lib/gen/models";
    String modelFile = "$modelFolder/$machineName.dart";

    //TODO: add cubit import (retrieve from AST)

    String stateMachineStringified = stateMachineTemplate(stateMachine);

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
