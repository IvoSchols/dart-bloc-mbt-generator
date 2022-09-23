import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'conditional_ab_complex_state.dart';

class ConditionalAbComplexCubit extends Cubit<ConditionalAbComplexState> {
  ConditionalAbComplexCubit() : super(ConditionalA());

  // void goToA() => emit(ConditionalA());

  // void goToBool(bool allowed) => {
  //       if (allowed) {emit(ConditionalBool())},
  //       emit(ConditionalA())
  //     };

  void goToInt(int value) => {
        if (value == 0)
          {
            // 0
            emit(Conditional0())
          }
        else if (value >= 3)
          {
            // 3
            emit(Conditional3())
          }
        else if (value <= -12)
          {
            // [...,-12]
            emit(ConditionalMinus12())
          }
        else if (value > -8)
          {
            // [-7,...]
            emit(ConditionalMinus7())
          }
        else if (value < -8)
          {
            // [-9,...]
            emit(ConditionalMinus9())
          }
        else
          {
            // [-10]
            emit(ConditionalMinus8())
          }
      };

  // void goToString(String value) => {
  //       if (value == 'foo')
  //         {emit(ConditionalStringFoo())}
  //       else if (value == 'bar')
  //         {emit(ConditionalStringBar())}
  //     };
}
