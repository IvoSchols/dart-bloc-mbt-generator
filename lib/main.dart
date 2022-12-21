import 'package:dart_bloc_mbt_generator/examples/cubit_examples/traffic_light/statemachine/traffic_light_statemachine.dart';
import 'package:dart_bloc_mbt_generator/file_generator/model_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/file_generator/test_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/zhang_path_generator.dart';
import 'package:simple_state_machine/state_machine.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';

Future<void> main() async {
  // Generate finite state machine model from cubit and write to file
  List<String> relativePaths = [];

//   relativePaths
//       .add("examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart");
//   relativePaths.add(
//       "examples/cubit_examples/conditional_ab/cubit/conditional_ab_cubit.dart");
//   relativePaths.add(
//       "examples/cubit_examples/conditional_ab_negated/cubit/conditional_ab_negated_cubit.dart");
  relativePaths.add(
      "examples/cubit_examples/traffic_light/cubit/traffic_light_cubit.dart");
//   relativePaths.add(
//       "examples/cubit_examples/light_switch/cubit/light_switch_cubit.dart");
//   relativePaths.add(
//       "examples/cubit_examples/light_switch_deadcode/cubit/light_switch_deadcode_cubit.dart");
//   relativePaths.add(
//       "examples/cubit_examples/conditional_ab_complex/cubit/conditional_ab_complex_cubit.dart");

  for (String relativePath in relativePaths) {
    //StateMachine stateMachine = Analyzer.analyzeSingleFile(relativePath);
    StateMachine stateMachine = constructTrafficLightStatemachine();

    StateMachineModelGenerator().writeModel(stateMachine);
    // final StateMachine machine = constructSimpleAbStatemachine();

    //Generate tests from finite state machine model DFS walks and write tests to file
    //

    final PathGenerator pathGenerator = ZhangPathGenerator();
    final List<Path> paths = pathGenerator.generatePaths(stateMachine);

    TestGenerator testGenerator = CubitGenerator(relativePath, stateMachine);
    await testGenerator.writeTests(paths);
  }
}
