import 'package:bloc/bloc.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:state_machine/state_machine.dart';

abstract class TestOracle {
  factory TestOracle(BlocBase blocBase, StateMachine machine) {
    switch (blocBase.runtimeType) {
      case Cubit:
        return CubitOracle(blocBase as Cubit<dynamic>, machine);
      case Bloc:
        return BlocOracle(blocBase as Bloc<dynamic, dynamic>, machine);
      default:
        throw Exception("Unknown bloc type");
    }
  }
  void test(List<Paths> paths);
}

class CubitOracle implements TestOracle {
  Cubit<dynamic> _cubit;
  StateMachine _machine;

  CubitOracle(this._cubit, this._machine);

  void test(List<Paths> paths) {}
}

class BlocOracle implements TestOracle {
  Bloc _bloc;
  StateMachine _machine;

  BlocOracle(this._bloc, this._machine);

  void test(List<Paths> paths) {}
}
