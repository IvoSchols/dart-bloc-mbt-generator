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
      'emits [Green, Red, Yellow, Exception, Green, Red, Yellow, Exception, Green, Red, Yellow]',
      build: () => trafficLightCubit,
      act: (cubit) => [
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red"),
        cubit.changeTrafficLightTo("yellow"),
        cubit.changeTrafficLightTo(""),
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red"),
        cubit.changeTrafficLightTo("yellow"),
        cubit.changeTrafficLightTo(""),
        cubit.changeTrafficLightTo("green"),
        cubit.changeTrafficLightTo("red"),
        cubit.changeTrafficLightTo("yellow")
      ],
      expect: () => [
        Green(),
        Red(),
        Yellow(),
        Exception(),
        Green(),
        Red(),
        Yellow(),
        Exception(),
        Green(),
        Red(),
        Yellow()
      ],
      errors: (() => []),
    );
  });
}
