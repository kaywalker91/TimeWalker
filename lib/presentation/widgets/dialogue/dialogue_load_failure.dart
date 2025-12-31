import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

/// 대화 로드 실패 위젯
/// 
/// 대화 데이터 로드에 실패했을 때 표시되는 전체 화면 에러 UI입니다.
class DialogueLoadFailure extends StatelessWidget {
  /// 에러 메시지
  final String message;
  
  /// 닫기 버튼 콜백
  final VoidCallback onClose;
  
  /// 재시도 콜백 (선택)
  final VoidCallback? onRetry;

  const DialogueLoadFailure({
    super.key,
    required this.message,
    required this.onClose,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(responsive.padding(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: responsive.iconSize(64),
                ),
                SizedBox(height: responsive.spacing(16)),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: responsive.fontSize(16),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.spacing(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (onRetry != null) ...[
                      OutlinedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('다시 시도'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      SizedBox(width: responsive.spacing(16)),
                    ],
                    ElevatedButton(
                      onPressed: onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                      ),
                      child: Text(l10n.common_close),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
