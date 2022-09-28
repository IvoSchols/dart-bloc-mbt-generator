import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/light_switch/cubit/light_switch_cubit.dart';

void main() {
  group('LightSwitchCubit', () {
    late LightSwitchCubit lightSwitchCubit;

    setUp(() {
      lightSwitchCubit = LightSwitchCubit();
    });

    blocTest<LightSwitchCubit, LightSwitchState>(
      'emits [On, Off, On, Off, On, Off, On, Off, On, Off, On]',
      build: () => lightSwitchCubit,
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
