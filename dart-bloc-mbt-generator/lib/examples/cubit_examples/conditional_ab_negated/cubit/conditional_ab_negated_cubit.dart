import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conditional_ab_negated_state.dart';

class ConditionalAbNegatedCubit extends Cubit<ConditionalAbNegatedState> {
  ConditionalAbNegatedCubit() : super(ConditionalA());

  void goToA() => emit(ConditionalA());

  void goToB(bool allowed) => {
        if (!allowed) {emit(ConditionalB())}
      };
}
