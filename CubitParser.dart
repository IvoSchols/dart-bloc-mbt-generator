import 'FiniteStateMachineCubit.dart';
import 'FiniteStateMachineParser.dart';

class CubitParser implements FiniteStateMachineParser {
  @override
  //Parse Cubit Lines read from file
  FiniteStateMachineCubit parse(List<String> lines) {
    lines.forEach((line) {
      print(line);
    });
    return FiniteStateMachineCubit(Set<String>(), "Set<int>()", Set<String>());
    throw UnimplementedError();
  }
}
