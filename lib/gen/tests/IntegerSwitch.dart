import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/integer_switch/cubit/integer_switch_cubit.dart';

void main() {
  group('IntegerSwitchCubit', () {
    late IntegerSwitchCubit integerSwitchCubit;

    setUp(() {
      integerSwitchCubit = IntegerSwitchCubit();
    });

    blocTest<IntegerSwitchCubit, IntegerSwitchState>(
      'emits [Minus20, FourtySeven, Minus20, FourtySeven, Minus20, FourtySeven, Minus20, FourtySeven, Minus20, FourtySeven, Minus20]',
      build: () => integerSwitchCubit,
      act: (cubit) => [
        cubit.integerSwitch(-20),
        cubit.integerSwitch(47),
        cubit.integerSwitch(-20),
        cubit.integerSwitch(47),
        cubit.integerSwitch(-20),
        cubit.integerSwitch(47),
        cubit.integerSwitch(-20),
        cubit.integerSwitch(47),
        cubit.integerSwitch(-20),
        cubit.integerSwitch(47),
        cubit.integerSwitch(-20)
      ],
      expect: () => [
        Minus20(),
        FourtySeven(),
        Minus20(),
        FourtySeven(),
        Minus20(),
        FourtySeven(),
        Minus20(),
        FourtySeven(),
        Minus20(),
        FourtySeven(),
        Minus20()
      ],
      errors: (() => []),
    );
  });
}
