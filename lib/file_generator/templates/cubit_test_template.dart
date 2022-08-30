import 'dart:collection';

import 'package:state_machine/state_machine.dart';

import '../../path_generator/path_generator.dart';

//Should accept a set of traces and generate a test case for each trace
String cubitTestTemplate(
    List<String> imports, StateMachine sm, List<Path> paths) {
  final String name = sm.name;
  // ignore: unused_local_variable
  final List<State> states = sm.states;
  // ignore: unused_local_variable
  final String variable;

  // final Set<Transition> transitions = sm.transitions;
  // ignore: unused_local_variable
  final State startingState = sm.initial;
  return '''
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
${_imports(imports)}


void main() {
  group('${_pascalCase(name)}Cubit', () {
    late ${_pascalCase(name)}Cubit ${_camelCase(name)}Cubit;

    setUp(() {
      ${_camelCase(name)}Cubit = ${_pascalCase(name)}Cubit();
    });

    ${_tests(name, paths)}
  });
}

''';
}

String _imports(List<String> imports) => imports.map((import) => '''
    import '$import';
  ''').join();

//First letter to uppercase
String _pascalCase(String str) =>
    str.substring(0, 1).toUpperCase() + str.substring(1);
//First letter to lowercase
String _camelCase(String str) =>
    str.substring(0, 1).toLowerCase() + str.substring(1);

String _tests(String name, List<Path> paths) => paths.map((path) => '''

    blocTest<${_pascalCase(name)}Cubit, ${_pascalCase(name)}State>(
      'emits ${path.transitions.map((t) => _pascalCase(t.to.name)).toList()}',
      build: () => ${_camelCase(name)}Cubit,
      act: (cubit) => ${path.transitions.map((t) => "cubit.${_callCubitFunction(t, path.pathInput)}").toList()},
      expect: () => ${path.transitions.map((t) => "${_pascalCase(t.to.name)}()").toList()},
    );
  ''').join();
// test('${_camelCase(path.pathInput.keys.first)}', () {
//   ${_camelCase(path.pathInput.keys.first)}();
//   expect(${_camelCase(path.pathInput.keys.first)}, emitsInOrder([
//     ${_camelCase(path.pathInput.values.first)}(),
//     ${_camelCase(path.pathInput.values.last)}(),
//   ]));
// });

String _callCubitFunction(
    Transition transition, Map<String, String> variableValues) {
  final String functionName = _camelCase(transition.name);
  final LinkedHashMap<String, String> inputTypes = transition.inputTypes;

  final String requiredFunctionParameters =
      inputTypes.keys.map((key) => "${variableValues[key]}").join(", ");

  // This is for named parameters
  // final String functionParameters =
  //     inputTypes.keys.map((key) => "$key: ${variableValues[key]}").join(", ");

  final String functionCall = "$functionName($requiredFunctionParameters)";
  return functionCall;
}
