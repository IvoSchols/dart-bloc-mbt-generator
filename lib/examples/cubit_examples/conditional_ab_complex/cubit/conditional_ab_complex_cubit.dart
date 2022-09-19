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
        else if (value >= 1)
          {
            // 1
            emit(Conditional1())
          }
        else if (value <= 2)
          {
            // [...,-1],2
            emit(Conditional2())
          }
        else if (value > 2)
          {
            // 3
            emit(Conditional3())
          }
        else if (value < 5)
          {
            // 4
            emit(Conditional4())
          }
        else
          {
            // [5,...]
            emit(Conditional5())
          }
      };

  // void goToString(String value) => {
  //       if (value == 'foo')
  //         {emit(ConditionalStringFoo())}
  //       else if (value == 'bar')
  //         {emit(ConditionalStringBar())}
  //     };
}
