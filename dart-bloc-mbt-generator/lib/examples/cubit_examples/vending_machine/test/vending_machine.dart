import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/vending_machine/cubit/vending_machine_cubit.dart';

void main() {
  group('ConditionalAbNegatedCubit', () {
    late VendingMachineCubit vendingMachineCubit;

    setUp(() {
      vendingMachineCubit = VendingMachineCubit();
    });

    blocTest<VendingMachineCubit, VendingMachineState>(
      'emits []',
      build: () => vendingMachineCubit,
      act: (cubit) => [],
      expect: () => [],
    );
  });
}
