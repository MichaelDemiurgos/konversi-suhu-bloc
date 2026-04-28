abstract class TempEvent {}

class InputChanged extends TempEvent {
  final double val;
  InputChanged(this.val);
}

class UnitChanged extends TempEvent {
  final String unit;
  UnitChanged(this.unit);
}