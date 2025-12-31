import 'package:equatable/equatable.dart';

class QuizCategory extends Equatable {
  final String id;
  final String title;
  final String description;

  const QuizCategory({
    required this.id,
    required this.title,
    required this.description,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, description];
}
