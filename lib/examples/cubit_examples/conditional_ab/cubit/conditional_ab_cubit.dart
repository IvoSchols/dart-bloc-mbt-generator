import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conditional_ab_state.dart';

class ConditionalAbCubit extends Cubit<ConditionalAbState> {
  ConditionalAbCubit() : super(ConditionalA());

  void goToA() => emit(ConditionalA());
  void goToB(bool allowed) => {
        if (allowed) {emit(ConditionalB())}
      };
}
