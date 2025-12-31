import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/audio_constants.dart';

import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/quiz/widgets/quiz_widgets.dart';

/// 퀴즈 화면
/// 
/// "시간의 문" 테마 - 두루마리 스타일 카드
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  String _selectedCategoryId = 'all';
  QuizFilterType _selectedFilter = QuizFilterType.all;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[QuizScreen] initState');
    
    // BGM 초기화 (build가 아닌 initState에서 한 번만 실행)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;
      
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmQuiz) {
        ref.read(bgmControllerProvider.notifier).playQuizBgm();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('[QuizScreen] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(quizCategoryListProvider);
    final quizListAsync = _selectedCategoryId == 'all'
        ? ref.watch(quizListProvider)
        : ref.watch(quizListByCategoryProvider(_selectedCategoryId));
    final userProgress = ref.watch(userProgressProvider).valueOrNull;
    final completedQuizIds = userProgress?.completedQuizIds ?? [];

    // BGM은 initState에서 처리됨 (build에서 중복 실행 방지)

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 커스텀 앱바
              _buildAppBar(context, completedQuizIds.length),
              
              // 필터 타입 선택 (전체 / 맞춘 퀴즈)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    QuizFilterToggleButton(
                      label: AppLocalizations.of(context)!.quiz_filter_all,
                      icon: Icons.list_alt,
                      isSelected: _selectedFilter == QuizFilterType.all,
                      onTap: () => setState(() => _selectedFilter = QuizFilterType.all),
                    ),
                    const SizedBox(width: 8),
                    QuizFilterToggleButton(
                      label: AppLocalizations.of(context)!.quiz_filter_completed,
                      icon: Icons.check_circle_outline,
                      isSelected: _selectedFilter == QuizFilterType.completed,
                      count: completedQuizIds.length,
                      onTap: () => setState(() => _selectedFilter = QuizFilterType.completed),
                    ),
                  ],
                ),
              ),
              
              // Category Filter
              categoriesAsync.when(
                data: (categories) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      QuizCategoryChip(
                        label: AppLocalizations.of(context)!.quiz_category_all,
                        isSelected: _selectedCategoryId == 'all',
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategoryId = 'all');
                        },
                      ),
                      const SizedBox(width: 8),
                      ...categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: QuizCategoryChip(
                            label: category.title,
                            isSelected: _selectedCategoryId == category.id,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCategoryId = category.id);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                loading: () => const SizedBox(
                  height: 50, 
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
                error: (_, _) => const SizedBox(),
              ),
              
              // Quiz List
              Expanded(
                child: quizListAsync.when(
                  data: (quizzes) {
                    // 필터 적용
                    final filteredQuizzes = _selectedFilter == QuizFilterType.completed
                        ? quizzes.where((q) => completedQuizIds.contains(q.id)).toList()
                        : quizzes;
                    
                    if (filteredQuizzes.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredQuizzes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final quiz = filteredQuizzes[index];
                        final isCompleted = completedQuizIds.contains(quiz.id);
                        return QuizCard(
                          quiz: quiz,
                          isCompleted: isCompleted,
                          showReviewMode: _selectedFilter == QuizFilterType.completed,
                          onDetailShow: () => _showQuizDetailSheet(context, quiz),
                        );
                      },
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  error: (e, s) => Center(
                    child: Text(
                      'Error: $e', 
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppBar(BuildContext context, int completedCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 뒤로가기 버튼
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          
          // 타이틀
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.quiz_title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          // 완료 통계 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: AppColors.success),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.quiz_completed_count(completedCount),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _selectedFilter == QuizFilterType.completed 
                  ? Icons.emoji_events_outlined 
                  : Icons.quiz_outlined,
              size: 64,
              color: AppColors.textDisabled,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedFilter == QuizFilterType.completed
                ? AppLocalizations.of(context)!.quiz_empty_completed
                : AppLocalizations.of(context)!.quiz_empty_all,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 퀴즈 상세 보기 바텀시트
  void _showQuizDetailSheet(BuildContext context, Quiz quiz) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => QuizDetailSheet(quiz: quiz),
    );
  }
}

