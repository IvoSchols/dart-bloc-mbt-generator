import 'package:dart_bloc_mbt_generator/file_generator/model_generator.dart';
import 'package:dart_bloc_mbt_generator/file_generator/templates/state_machine_template.dart';
import 'package:dart_bloc_mbt_generator/path_generator/path_generator.dart';
import 'package:dart_bloc_mbt_generator/file_generator/test_generator.dart';
import 'package:dart_bloc_mbt_generator/path_generator/zhang_path_generator.dart';
import 'package:state_machine/state_machine.dart';
import 'package:dart_bloc_mbt_generator/code_analyzer/analyzer.dart';

Future<void> main() async {
  // Generate finite state machine model from cubit and write to file
  // String relativePath =
  //     'examples/cubit_examples/simple_ab/cubit/simple_ab_cubit.dart';

  // String relativePath =
  //     'examples/cubit_examples/conditional_ab/cubit/conditional_ab_cubit.dart';

  // String relativePath =
  //     'examples/cubit_examples/conditional_ab_negated/cubit/conditional_ab_negated_cubit.dart';

  String relativePath =
      'examples/cubit_examples/traffic_light/cubit/traffic_light_cubit.dart';

  // String relativePath =
  //     'examples/cubit_examples/conditional_ab_complex/cubit/conditional_ab_complex_cubit.dart';

  StateMachine stateMachine = Analyzer.analyzeSingleFile(relativePath);

  //TODO: reimplement
  StateMachineModelGenerator(relativePath).writeModel(stateMachine);
  // final StateMachine machine = constructSimpleAbStatemachine();

  //Generate tests from finite state machine model DFS walks and write tests to file
  //

  final PathGenerator pathGenerator = ZhangPathGenerator();
  final List<Path> paths = pathGenerator.generatePaths(stateMachine);

  TestGenerator testGenerator = CubitGenerator(relativePath, stateMachine);
  await testGenerator.writeTests(paths);
}
