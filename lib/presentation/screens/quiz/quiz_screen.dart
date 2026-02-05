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
    final totalPoints = userProgress?.totalKnowledge ?? 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.timePortal,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Cleaner AppBar
              _buildAppBar(context),
              
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // 2. Summary Card
                    SliverToBoxAdapter(
                      child: quizListAsync.when(
                        data: (quizzes) => QuizSummaryCard(
                          completedCount: completedQuizIds.length,
                          totalCount: quizzes.length,
                          totalPoints: totalPoints,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (error, _) => const SizedBox.shrink(),
                      ),
                    ),

                    // 3. Filters & Categories
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filter Tabs
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                QuizFilterTab(
                                  label: AppLocalizations.of(context)!.quiz_filter_all,
                                  isSelected: _selectedFilter == QuizFilterType.all,
                                  onTap: () => setState(() => _selectedFilter = QuizFilterType.all),
                                ),
                                const SizedBox(width: 12),
                                QuizFilterTab(
                                  label: AppLocalizations.of(context)!.quiz_filter_completed,
                                  isSelected: _selectedFilter == QuizFilterType.completed,
                                  onTap: () => setState(() => _selectedFilter = QuizFilterType.completed),
                                ),
                              ],
                            ),
                          ),

                          // Category Cards
                          categoriesAsync.when(
                            data: (categories) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  QuizCategoryCard(
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
                                      child: QuizCategoryCard(
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
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // 4. Quiz List
                    quizListAsync.when(
                      data: (quizzes) {
                        final filteredQuizzes = _selectedFilter == QuizFilterType.completed
                            ? quizzes.where((q) => completedQuizIds.contains(q.id)).toList()
                            : quizzes;
                        
                        if (filteredQuizzes.isEmpty) {
                          return SliverFillRemaining(
                            child: _buildEmptyState(context),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final quiz = filteredQuizzes[index];
                              final isCompleted = completedQuizIds.contains(quiz.id);
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: QuizCard(
                                  quiz: quiz,
                                  isCompleted: isCompleted,
                                  showReviewMode: _selectedFilter == QuizFilterType.completed,
                                  onDetailShow: () => _showQuizDetailSheet(context, quiz),
                                ),
                              );
                            },
                            childCount: filteredQuizzes.length,
                          ),
                        );
                      },
                      loading: () => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => SliverFillRemaining(
                        child: Center(child: Text('Error: $e')),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Hero(
            tag: 'quiz_hero_icon',
            child: Icon(Icons.quiz, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.quiz_title,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Optional: You could add a simple Help button here if needed
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
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => QuizDetailSheet(quiz: quiz),
    );
  }
}

