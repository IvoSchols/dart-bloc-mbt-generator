import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'simple_ab_state.dart';

class SimpleAbCubit extends Cubit<SimpleAbState> {
  SimpleAbCubit() : super(SimpleAbInitial());
}
