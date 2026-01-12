import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/services/achievement_service.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/achievement_unlock_card.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';


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
  bool _wasAlreadyCompleted = false; // 이미 맞춘 퀴즈인지 여부
  List<Achievement> _unlockedAchievements = []; // 새로 달성한 업적

  // Item State
  bool _isTimerFrozen = false;
  bool _isHintUsed = false;
  bool _isTimeFreezeUsed = false;
  List<String> _hiddenOptions = [];

  @override
  void initState() {
    super.initState();
    debugPrint('[QuizPlayScreen] initState - quizId=${widget.quizId}');
  }

  @override
  void dispose() {
    debugPrint('[QuizPlayScreen] dispose - quizId=${widget.quizId}');
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int seconds) {
    _remainingTime = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTimerFrozen) return; // 타이머 정지 상태

      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _submitAnswer(timeout: true);
      }
    });
  }

  Future<void> _useHint(String correctAnswer, List<String> allOptions) async {
    final notifier = ref.read(userProgressProvider.notifier);
    final success = await notifier.consumeItem('item_hint_01');

    if (success && mounted) {
      setState(() {
        _isHintUsed = true;
        
        // 정답을 제외한 오답 목록 추출
        final wrongOptions = allOptions.where((o) => o != correctAnswer).toList();
        // 무작위로 2개 선택하여 숨김 처리 (오답이 2개 미만이면 전체 숨김)
        if (wrongOptions.length > 2) {
          wrongOptions.shuffle(Random());
          _hiddenOptions = wrongOptions.take(2).toList();
        } else {
          _hiddenOptions = wrongOptions;
        }

        // 만약 선택된 답이 숨겨진 옵션에 있다면 선택 해제
        if (_hiddenOptions.contains(_selectedAnswer)) {
          _selectedAnswer = null;
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('힌트 사용! 오답이 제거되었습니다.'), backgroundColor: AppColors.secondary),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이템 사용 실패!'), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _useTimeFreeze() async {
    final notifier = ref.read(userProgressProvider.notifier);
    final success = await notifier.consumeItem('item_time_freeze_01');

    if (success && mounted) {
      setState(() {
        _isTimeFreezeUsed = true;
        _isTimerFrozen = true;
      });

      // 10초 후 타이머 재개
      Timer(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            _isTimerFrozen = false;
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('크로노스 타임 스톱! 시간이 10초간 멈춥니다.'), backgroundColor: AppColors.info),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이템 사용 실패!'), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _submitAnswer({bool timeout = false}) async {
    _timer?.cancel();
    bool isCorrect = false;
    final quiz = ref.read(quizByIdProvider(widget.quizId)).value;

    if (!timeout && quiz != null) {
      isCorrect = quiz.checkAnswer(_selectedAnswer ?? '');
    }

    if (!mounted) return;
    
    setState(() {
      _isSubmitted = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect && quiz != null) {
      // Update User Progress
      final userProgress = ref.read(userProgressProvider).value;
      if (userProgress != null) {
        // 이미 맞춘 퀴즈인지 확인 (중복 포인트 방지)
        final alreadyCompleted = userProgress.isQuizCompleted(quiz.id);
        
        if (!mounted) return;
        
        setState(() {
          _wasAlreadyCompleted = alreadyCompleted;
        });
        
        if (!alreadyCompleted) {
          // 새로운 정답: 포인트 획득 및 완료 목록에 추가
          var newProgress = userProgress.copyWith(
            totalKnowledge: userProgress.totalKnowledge + quiz.basePoints,
            completedQuizIds: [...userProgress.completedQuizIds, quiz.id],
          );
          
          // 업적 체크
          final achievementService = ref.read(achievementServiceProvider);
          final unlocked = achievementService.checkAllAfterQuiz(
            userProgress: newProgress,
            completedQuiz: quiz,
            quizCategory: null, // TODO: 퀴즈 카테고리 정보 전달
          );
          
          // 업적 달성 시 achievementIds에 추가 및 보너스 포인트 지급
          if (unlocked.isNotEmpty) {
            final bonusPoints = achievementService.calculateBonusPoints(unlocked);
            newProgress = newProgress.copyWith(
              achievementIds: [
                ...newProgress.achievementIds,
                ...unlocked.map((a) => a.id),
              ],
              totalKnowledge: newProgress.totalKnowledge + bonusPoints,
            );
            
            if (!mounted) return;
            
            setState(() {
              _unlockedAchievements = unlocked;
            });
            
            // 업적 알림 Provider에 추가
            ref.read(achievementNotifierProvider.notifier).addUnlockedAchievements(unlocked);
          }
          
          final repository = ref.read(userProgressRepositoryProvider);
          await repository.saveUserProgress(newProgress);
          
          if (!mounted) return;
          ref.invalidate(userProgressProvider);
        }
        // 이미 맞춘 문제는 복습으로 간주, 포인트 추가 없음
      }
    }
  }

  /// eraId에 따른 버튼 레이블 반환
  String _getEraButtonLabel(String eraId) {
    switch (eraId) {
      case 'korea_joseon':
        return '조선시대로 이동';
      case 'korea_three_kingdoms':
        return '삼국시대로 이동';
      case 'korea_goryeo':
        return '고려시대로 이동';
      case 'korea_gaya':
        return '가야시대로 이동';
      case 'korea_ancient':
        return '고조선으로 이동';
      default:
        return '시대 탐험으로 이동';
    }
  }

  // ... inside _QuizPlayScreenState
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C3E), // Dark theme consistent with quiz screen
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white24),
        ),
        title: Text(
          AppLocalizations.of(context)!.quiz_help_title,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          AppLocalizations.of(context)!.quiz_help_msg,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_close, style: const TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizByIdProvider(widget.quizId));
    final userProgressAsync = ref.watch(userProgressProvider);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
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
                        Stack(
                          children: [
                            LinearProgressIndicator(
                              value: _remainingTime / quiz.timeLimitSeconds,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation(
                                _isTimerFrozen 
                                    ? Colors.cyanAccent 
                                    : (_remainingTime < 5 ? Colors.red : Colors.amber),
                              ),
                              minHeight: 6,
                            ),
                            if (_isTimerFrozen)
                              const Positioned.fill(
                                child: Center(
                                  child: Icon(Icons.lock_clock, size: 16, color: Colors.cyanAccent),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isTimerFrozen ? 'Time Frozen!' : 'Time Remaining: ${_remainingTime}s',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: _isTimerFrozen ? Colors.cyanAccent : Colors.white54,
                            fontWeight: _isTimerFrozen ? FontWeight.bold : FontWeight.normal,
                          ),
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
                          // 힌트로 숨겨진 옵션은 렌더링 하지 않음 (또는 비활성화)
                          if (_hiddenOptions.contains(option)) {
                             return Padding(
                              padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                              child: Container(
                                padding: EdgeInsets.all(optionPadding),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Text(
                                  '???',
                                  style: TextStyle(
                                    color: Colors.white12,
                                    fontSize: optionFontSize,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

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
                        
                        // Item Buttons (Only show when not submitted)
                        if (!_isSubmitted) ...[
                          userProgressAsync.when(
                            data: (userProgress) {
                              final hasHint = userProgress.inventoryIds.contains('item_hint_01');
                              final hasFreeze = userProgress.inventoryIds.contains('item_time_freeze_01');
                              
                              return Row(
                                children: [
                                  Expanded(
                                    child: _buildItemButton(
                                      icon: Icons.lightbulb,
                                      label: 'Hint',
                                      count: userProgress.inventoryIds.where((id) => id == 'item_hint_01').length,
                                      isEnabled: hasHint && !_isHintUsed,
                                      onTap: () => _useHint(quiz.correctAnswer, quiz.options),
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildItemButton(
                                      icon: Icons.hourglass_top,
                                      label: 'Freeze',
                                      count: userProgress.inventoryIds.where((id) => id == 'item_time_freeze_01').length,
                                      isEnabled: hasFreeze && !_isTimeFreezeUsed,
                                      onTap: _useTimeFreeze,
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                        ],

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
                                      _isCorrect 
                                          ? (_wasAlreadyCompleted 
                                              ? 'Correct! (다시 풀기)'
                                              : 'Correct! +${quiz.basePoints} pts')
                                          : 'Incorrect!',
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
                              
                              // 업적 달성 표시
                              if (_unlockedAchievements.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                ..._unlockedAchievements.map((achievement) => AchievementUnlockCard(
                                  achievement: achievement,
                                )),
                              ],
                              
                              const SizedBox(height: 16),
                              
                              // 정답 시: 해당 시대로 이동 버튼
                              if (_isCorrect) 
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (!mounted) return;
                                    // 퀴즈의 시대(eraId)로 이동
                                    // go()를 사용하여 스택 교체 (뒤로가기 시 퀴즈/대화로 돌아가지 않음)
                                    context.go('/era/${quiz.eraId}');
                                  },
                                  icon: const Icon(Icons.explore, size: 20),
                                  label: Text(_getEraButtonLabel(quiz.eraId), style: const TextStyle(fontSize: 16)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                )
                              else
                                // 오답 시: 닫기 버튼
                                ElevatedButton(
                                  onPressed: () {
                                    if (!mounted) return;
                                    context.pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('닫기', style: TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget _buildItemButton({
    required IconData icon,
    required String label,
    required int count,
    required bool isEnabled,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        disabledBackgroundColor: Colors.white10,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isEnabled ? color.withValues(alpha: 0.5) : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isEnabled ? color : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isEnabled ? color : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

