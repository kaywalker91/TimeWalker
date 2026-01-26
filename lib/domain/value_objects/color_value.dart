import 'package:equatable/equatable.dart';

class ColorValue extends Equatable {
  final int value;

  const ColorValue(this.value);

  @override
  List<Object?> get props => [value];
}
