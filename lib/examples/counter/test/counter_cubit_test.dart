import 'package:bloc_test/bloc_test.dart';
import '../code/counter_cubit.dart';

class MockCounterBloc extends MockBloc<CounterEvent, int> implements CounterBloc {}
class MockCounterCubit extends MockCubit<int> implements CounterCubit {}group('CounterBloc', () {
  blocTest(
    'emits [] when nothing is added',
    build: () => CounterBloc(),
    expect: () => [],
  );

  blocTest(
    'emits [1] when CounterIncrementPressed is added',
    build: () => CounterBloc(),
    act: (bloc) => bloc.add(CounterIncrementPressed()),
    expect: () => [1],
  );
});