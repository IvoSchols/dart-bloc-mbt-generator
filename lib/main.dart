import 'package:statemachine/statemachine.dart';

void main(List<String> args) {
  final machine = Machine<String>();
  final stateA = machine.newState('A');
  final stateB = machine.newState('B');

  stateA.onEntry(() => print('Entering A'));
  stateA.onExit(() => print('Exiting A'));
  stateB.onEntry(() => print('Entering B'));
  stateB.onExit(() => print('Exiting B'));

  machine.start();
  machine.context['x'] = int;

  stateA.guards[stateB] = Guard([(context) => context["x"] > 5]);
  stateB.guards[stateA] = Guard([(context) => false]);

  stateB.enter();
  stateA.enter();

  // PathGenerator pathGenerator = SimplePathGenerator();
  // List<Paths> allPaths = pathGenerator.generateAllPaths(counterCubit);
  // print(allPaths.toString());
}
