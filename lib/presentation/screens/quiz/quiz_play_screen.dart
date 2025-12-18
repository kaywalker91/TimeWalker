import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class QuizPlayScreen extends ConsumerStatefulWidget {
  final String quizId;

  const QuizPlayScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  Timer? _timer;
  int _remainingTime = 0;
  String? _selectedAnswer;
  bool _isSubmitted = false;
  bool _isCorrect = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int seconds) {
    _remainingTime = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _submitAnswer(timeout: true);
      }
    });
  }

  void _submitAnswer({bool timeout = false}) async {
    _timer?.cancel();
    bool isCorrect = false;
    final quiz = ref.read(quizByIdProvider(widget.quizId)).value;

    if (!timeout && quiz != null) {
      isCorrect = quiz.checkAnswer(_selectedAnswer ?? '');
    }

    setState(() {
      _isSubmitted = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect && quiz != null) {
      // Update User Progress
      final userProgress = ref.read(userProgressProvider).value;
      if (userProgress != null) {
        final newProgress = userProgress.copyWith(
          totalKnowledge: userProgress.totalKnowledge + quiz.basePoints,
        );
        
        final repository = ref.read(userProgressRepositoryProvider);
        await repository.saveUserProgress(newProgress);
        ref.invalidate(userProgressProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizByIdProvider(widget.quizId));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Quiz Challenge'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
        ),
      ),
      body: quizAsync.when(
        data: (quiz) {
          if (quiz == null) return const Center(child: Text('Quiz not found'));
          
          // Start timer only once when data is loaded and not submitted
          if (_timer == null && !_isSubmitted) {
            _startTimer(quiz.timeLimitSeconds);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxHeight < 600;
              final questionFontSize = isSmallScreen ? 18.0 : 24.0;
              final optionFontSize = isSmallScreen ? 14.0 : 16.0;
              final optionPadding = isSmallScreen ? 14.0 : 20.0;
              final spacing = isSmallScreen ? 24.0 : 40.0;

              return SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (isSmallScreen ? 32 : 48),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Timer & Progress
                        LinearProgressIndicator(
                          value: _remainingTime / quiz.timeLimitSeconds,
                          backgroundColor: Colors.white10,
                          valueColor: AlwaysStoppedAnimation(
                            _remainingTime < 5 ? Colors.red : Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Time Remaining: ${_remainingTime}s',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white54),
                        ),
                        SizedBox(height: spacing),

                        // Question
                        Text(
                          quiz.question,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: questionFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: spacing),

                        // Options
                        ...quiz.options.map((option) {
                          final isSelected = _selectedAnswer == option;
                          Color tileColor = const Color(0xFF2C2C3E);
                          Color borderColor = Colors.white10;

                          if (_isSubmitted) {
                            if (quiz.checkAnswer(option)) {
                              tileColor = Colors.green.withValues(alpha: 0.2);
                              borderColor = Colors.green;
                            } else if (isSelected && !quiz.checkAnswer(option)) {
                              tileColor = Colors.red.withValues(alpha: 0.2);
                              borderColor = Colors.red;
                            }
                          } else if (isSelected) {
                            borderColor = Colors.amber;
                            tileColor = Colors.amber.withValues(alpha: 0.1);
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                            child: InkWell(
                              onTap: _isSubmitted ? null : () {
                                setState(() {
                                  _selectedAnswer = option;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(optionPadding),
                                decoration: BoxDecoration(
                                  color: tileColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor, width: 2),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: optionFontSize,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }),

                        const Spacer(),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Submit Button / Next Button
                        if (!_isSubmitted)
                          ElevatedButton(
                            onPressed: _selectedAnswer != null ? () => _submitAnswer() : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Submit Answer', style: TextStyle(color: Colors.black, fontSize: isSmallScreen ? 16 : 18, fontWeight: FontWeight.bold)),
                          )
                        else
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                                decoration: BoxDecoration(
                                  color: _isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _isCorrect ? 'Correct! +${quiz.basePoints} pts' : 'Incorrect!',
                                      style: TextStyle(
                                        color: _isCorrect ? Colors.green : Colors.red,
                                        fontSize: isSmallScreen ? 16 : 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      quiz.explanation,
                                      style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? 12 : 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context.pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white24,
                                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}
