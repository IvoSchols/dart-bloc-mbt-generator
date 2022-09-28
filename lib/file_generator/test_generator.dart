import 'dart:io';

import 'package:dart_bloc_mbt_generator/file_generator/file_generator_helpers.dart';
import 'package:dart_bloc_mbt_generator/file_generator/templates/cubit_test_template.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';

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

  Future<void> writeTests(List<Path> paths);
}

class CubitGenerator implements TestGenerator {
  final String _blocBasePath;
  final StateMachine _machine;

  CubitGenerator(this._blocBasePath, this._machine);

  @override
  Future<void> writeTests(List<Path> paths) async {
    String machineName = _machine.name;
    String testFolder = "lib/gen/tests";
    String testFile = "$testFolder/$machineName.dart";

    List<String> imports = ['package:dart_bloc_mbt_generator/$_blocBasePath'];

    String cubitTestsStringified = cubitTestTemplate(imports, _machine, paths);

    // Write string to file relative to the current directory
    File file = File(testFile);
    file.createSync(recursive: true);
    file.writeAsStringSync(cubitTestsStringified);

    print(file.toString());

    // Format the newly written test file
    FileGeneratorHelperFunctions.formatFiles([file.absolute.path]);
  }
}
