part of 'simple_ab_cubit.dart';

abstract class SimpleAbState extends Equatable {
  const SimpleAbState();

  @override
  List<Object> get props => [];
}

class SimpleA extends SimpleAbState {}

class SimpleB extends SimpleAbState {}
