import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vending_machine_state.dart';

class VendingMachineCubit extends Cubit<VendingMachineState> {
  VendingMachineCubit() : super(VendingMachineInitial());

  void addCoin(int coinValue) {
    if (state is VendingMachineFailure ||
        coinValue > 1 ||
        state.coinsInserted >= 2) {
      emit(VendingMachineFailure(
          coinsValue: state.coinsValue + coinValue,
          coinsInserted: state.coinsInserted + 1));
      emit(VendingMachineInitial());
    } else if (coinValue > 0 &&
        coinValue <= 1 &&
        (coinValue == 0.5 || coinValue == 1) &&
        state.coinsInserted <= 2) {
      emit(VendingMachineInProgress(
          coinsValue: state.coinsValue + coinValue,
          coinsInserted: state.coinsInserted + 1));

      if (state.coinsValue == 2) {
        emit(VendingMachineLoaded(coinsInserted: state.coinsInserted));
      }
    } else {
      throw Exception('Invalid coin value');
    }
  }

  void buy(/*String choice*/) {
    if (state is VendingMachineLoaded) {
      emit(VendingMachineSuccess(coinsInserted: state.coinsInserted));
      emit(VendingMachineInitial());
    }
  }
}
