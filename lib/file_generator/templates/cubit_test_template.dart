import 'package:dart_bloc_mbt_generator/code_analyzer/cubit/recursive_cubit_visitor.dart';

String cubitTestTemplate(List<String> imports, VisitedCubit vCubit) {
  final String name = vCubit.name;
  final Set<String> states = vCubit.states;
  final String variables;
  final Set<Transition> transitions = vCubit.transitions;
  final String startingState = vCubit.startingState;
  return '''
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
$_imports($imports);


void main() {
  group('${_pascalCase(name)}Cubit', () {
    late ${_pascalCase(name)}Cubit ${_camelCase(name)}Cubit;

    setUp(() {
      ${_camelCase(name)}Cubit = ${_pascalCase(name)}Cubit();
    });

    {{! test cases }}
    {{#tests}} <------------- DONT FORGET!!!
      blocTest<${_pascalCase(name)}Cubit, ${_pascalCase(name)}State>(
        'emits {{#states}} {{state}}() {{/states}}',
        build: () => {{cubit.camelCase()}},
        act: (cubit) => [{{#functions}} {{function}}, {{/functions}}],
        expect: () => [{{#states}} {{state.pascalCase()}}, {{/states}}],
      );
    {{/tests}}
  });
}

''';
}

String _imports(List<String> imports) => imports.map((import) => '''
    import '$import';
  ''').join();

String _states(Set<String> states) => states.map((state) => '''
    {{#if (state == startingState)}}
      {{state.pascalCase()}},
    {{/if}}
  ''').join();

//First letter to lowercase
String _pascalCase(String str) =>
    str.substring(0, 1).toLowerCase() + str.substring(1);

//First letter to uppercase
String _camelCase(String str) =>
    str.substring(0, 1).toUpperCase() + str.substring(1);
