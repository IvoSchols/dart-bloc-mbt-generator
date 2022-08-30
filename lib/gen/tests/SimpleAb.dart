import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
    import 'package:dart_bloc_mbt_generator/examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';
  


void main() {
  group('SimpleAbCubit', () {
    late SimpleAbCubit simpleAbCubit;

    setUp(() {
      simpleAbCubit = SimpleAbCubit();
    });

    
    blocTest<SimpleAbCubit, SimpleAbState>(
      'emits [SimpleB, SimpleA, SimpleB, SimpleA, SimpleB]',
      build: () => simpleAbCubit,
      act: (cubit) => [cubit.goToB(), cubit.goToA(), cubit.goToB(), cubit.goToA(), cubit.goToB()],
      expect: () => [SimpleB(), SimpleA(), SimpleB(), SimpleA(), SimpleB()],
    );
  
  });
}

