import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_bloc_mbt_generator/examples/cubit_examples/traffic_light/cubit/traffic_light_cubit.dart';

void main() {
  group('TrafficLightCubit', () {
    late TrafficLightCubit trafficLightCubit;

    setUp(() {
      trafficLightCubit = TrafficLightCubit();
    });

    blocTest<TrafficLightCubit, TrafficLightState>(
      'emits [Green, Red, Yellow, Green, Red, Yellow, Green, Red, Yellow, Green, Red]',
      build: () => trafficLightCubit,
      act: (cubit) => [
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red"),
        cubit.changeTrafficLightTo("yellow"),
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red"),
        cubit.changeTrafficLightTo("yellow"),
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red"),
        cubit.changeTrafficLightTo("yellow"),
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red")
      ],
      expect: () => [
        Green(),
        Red(),
        Yellow(),
        Green(),
        Red(),
        Yellow(),
        Green(),
        Red(),
        Yellow(),
        Green(),
        Red()
      ],
      errors: (() => []),
    );
  });
}
