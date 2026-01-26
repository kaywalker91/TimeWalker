import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/dialogue.dart';

/// 보상 획득 시 표시되는 알림 위젯
class RewardNotification extends StatelessWidget {
  final DialogueReward reward;
  final VoidCallback? onDismiss;

  const RewardNotification({
    super.key,
    required this.reward,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (!reward.hasReward) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.premiumGold,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: AppColors.premiumGold,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reward.knowledgePoints > 0)
                Text(
                  '+${reward.knowledgePoints} 지식',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (reward.unlockFactId != null)
                Text(
                  '역사 사실 해금!',
                  style: TextStyle(
                    color: Colors.amber[300],
                    fontSize: 12,
                  ),
                ),
              if (reward.unlockCharacterId != null)
                Text(
                  '인물 해금!',
                  style: TextStyle(
                    color: Colors.amber[300],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 보상 알림을 표시하는 오버레이
class RewardOverlay extends StatefulWidget {
  final DialogueReward? reward;
  final Duration displayDuration;

  const RewardOverlay({
    super.key,
    this.reward,
    this.displayDuration = const Duration(seconds: 2),
  });

  @override
  State<RewardOverlay> createState() => _RewardOverlayState();
}

class _RewardOverlayState extends State<RewardOverlay>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    if (widget.reward != null && widget.reward!.hasReward) {
      _showNotification();
    }
  }

  @override
  void didUpdateWidget(RewardOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reward != oldWidget.reward &&
        widget.reward != null &&
        widget.reward!.hasReward) {
      _showNotification();
    }
  }

  void _showNotification() {
    setState(() {
      _isVisible = true;
    });
    _controller.forward();

    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || widget.reward == null || !widget.reward!.hasReward) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: RewardNotification(reward: widget.reward!),
          ),
        ),
      ),
    );
  }
}

