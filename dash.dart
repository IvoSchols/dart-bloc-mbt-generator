import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('Dash', () {
    late Dash counterBloc;

    setUp(() {
      dash = Dash();
    });

    test('initial state is 0', () {
      expect(dash.state, 0);
    });
  });
}
