part of 'vending_machine_cubit.dart';

abstract class VendingMachineState extends Equatable {
  const VendingMachineState(
      {required this.coinsValue, required this.coinsInserted});

  final int coinsValue;
  final int coinsInserted;

  @override
  List<Object> get props => [coinsValue, coinsInserted];
}

class VendingMachineInitial extends VendingMachineState {
  VendingMachineInitial() : super(coinsValue: 0, coinsInserted: 0);
}

class VendingMachineInProgress extends VendingMachineState {
  VendingMachineInProgress(
      {required super.coinsValue, required super.coinsInserted});
}

class VendingMachineLoaded extends VendingMachineState {
  VendingMachineLoaded({required super.coinsInserted}) : super(coinsValue: 2);
}

class VendingMachineSuccess extends VendingMachineState {
  VendingMachineSuccess({required super.coinsInserted}) : super(coinsValue: 2);
}

class VendingMachineFailure extends VendingMachineState {
  VendingMachineFailure(
      {required super.coinsValue, required super.coinsInserted});
}
