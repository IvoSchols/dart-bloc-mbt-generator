import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/light_switch_deadcode/cubit/light_switch_deadcode_cubit.dart';

void main() {
  group('LightSwitchDeadcodeCubit', () {
    late LightSwitchDeadcodeCubit lightSwitchDeadcodeCubit;

    setUp(() {
      lightSwitchDeadcodeCubit = LightSwitchDeadcodeCubit();
    });

    blocTest<LightSwitchDeadcodeCubit, LightSwitchDeadcodeState>(
      'emits [On, Off, On, Off, On, Off, On, Off, On, Off, On]',
      build: () => lightSwitchDeadcodeCubit,
      act: (cubit) => [
        cubit.lightSwitch(true),
        cubit.lightSwitch(false),
        cubit.lightSwitch(true),
        cubit.lightSwitch(false),
        cubit.lightSwitch(true),
        cubit.lightSwitch(false),
        cubit.lightSwitch(true),
        cubit.lightSwitch(false),
        cubit.lightSwitch(true),
        cubit.lightSwitch(false),
        cubit.lightSwitch(true)
      ],
      expect: () => [
        On(),
        Off(),
        On(),
        Off(),
        On(),
        Off(),
        On(),
        Off(),
        On(),
        Off(),
        On()
      ],
      errors: (() => []),
    );
  });
}
