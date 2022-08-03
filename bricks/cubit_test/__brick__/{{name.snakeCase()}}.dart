{{! Add all standard imports and custom imports }}
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
{{#imports}}
  import '{{name.snakeCase()}}/{{{import}}}';
{{/imports}}


void main() {
  group('{{cubit.pascalCase()}}', () {
    late {{cubit.pascalCase()}} {{cubit.camelCase()}};

    setUp(() {
      {{cubit.camelCase()}} = {{cubit.pascalCase()}}();
    });

    {{! test cases }}
    {{#tests}}
      blocTest<{{cubit.pascalCase()}}, {{stateClass.pascalCase()}}>(
        'emits {{#states}} {{state}}() {{/states}}',
        build: () => {{cubit.camelCase()}},
        act: (cubit) => [{{#functions}} {{function}}, {{/functions}}],
        expect: () => [{{#states}} {{state.pascalCase()}}, {{/states}}],
      );
    {{/tests}}
  });
}
