import 'package:equatable/equatable.dart';

class TempState extends Equatable {
  final double input;
  final String dari;

  const TempState({this.input = 0, this.dari = 'Celsius'});

  @override
  List<Object> get props => [input, dari];
}