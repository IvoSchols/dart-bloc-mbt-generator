import 'dart:io';

import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';
import 'package:dart_bloc_mbt_generator/file_generator/templates/state_machine_template.dart';
import 'package:simple_state_machine/state_machine.dart';

class StateMachineModelGenerator {
  void writeModel(StateMachine stateMachine) {
    String machineName = stateMachine.name;

    String modelFolder = "lib/gen/models";
    String modelFile = "$modelFolder/$machineName.dart";

    String stateMachineStringified = stateMachineTemplate(stateMachine);

    // Write string to file relative to the current directory
    File file = File(modelFile);
    file.createSync(recursive: true);
    file.writeAsStringSync(stateMachineStringified);

    print(file.toString());

    String dirPath = '${Directory.current.path}/$modelFile';

    // Format the newly written model file
    FileGeneratorHelperFunctions.formatFiles([dirPath]);
  }
}
