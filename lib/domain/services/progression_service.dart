import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/user_progress.dart';

/// 해금 이벤트 유형
enum UnlockType {
  era,
  region,
  rank,
  feature,
}

/// 해금 이벤트 데이터
class UnlockEvent extends Equatable {
  final UnlockType type;
  final String id; // Era ID, Region ID, or formatted string for rank
  final String name; // Display name
  final String? message; // Optional message

  const UnlockEvent({
    required this.type,
    required this.id,
    required this.name,
    this.message,
  });

  @override
  List<Object?> get props => [type, id, name, message];
}

/// 진행 및 해금 처리를 담당하는 도메인 서비스
class ProgressionService {
  /// 현재 진행 상태를 기반으로 해금 가능한 항목을 확인합니다.
  /// 
  /// [currentProgress] : 현재 사용자 진행 상태
  /// [allEras] : 전체 시대 데이터 (기본값은 EraData.all)
  List<UnlockEvent> checkUnlocks(
    UserProgress currentProgress, {
    List<Era>? allEras,
  }) {
    final events = <UnlockEvent>[];
    final erasToCheck = allEras ?? EraData.all;

    // 1. 시대 해금 확인 (Era Unlocks)
    for (final era in erasToCheck) {
      if (_shouldUnlockEra(era, currentProgress)) {
        events.add(UnlockEvent(
          type: UnlockType.era,
          id: era.id,
          name: era.nameKorean,
          message: '${era.nameKorean} 시대가 해금되었습니다!',
        ));
      }
    }

    // 2. 등급 승급 확인 (Rank Promotion)
    final newRank = _calculateRank(currentProgress.totalKnowledge);
    if (newRank != currentProgress.rank) {
      // 등급 상승
      if (newRank.index > currentProgress.rank.index) {
        events.add(UnlockEvent(
          type: UnlockType.rank,
          id: newRank.name,
          name: newRank.displayName,
          message: '축하합니다! ${newRank.displayName} 등급으로 승급했습니다!',
        ));
      }
    }

    // 3. 지역 해금 확인 (Region Unlocks) -> 추후 구현
    
    return events;
  }

  /// 시대 해금 조건 충족 여부 판단
  bool _shouldUnlockEra(Era era, UserProgress progress) {
    // 이미 해금된 경우 패스
    if (progress.isEraUnlocked(era.id)) {
      return false;
    }

    // 기본 해금이거나 조건이 없는 경우
    if (era.unlockCondition.previousEraId == null) {
       // 보통 기본 해금이지만, UserProgress에 없다면 해금 대상으로 간주
       return true; 
    }

    final condition = era.unlockCondition;
    
    // 프리미엄 전용인 경우 현재는 false (나중에 IAP 연동)
    if (condition.isPremium) {
      return false;
    }

    // 이전 시대 진행률 체크
    if (condition.previousEraId != null) {
      final prevProgress = progress.getEraProgress(condition.previousEraId!);
      // 실수 연산 오차 고려하여 비교
      if (prevProgress >= condition.requiredProgress - 0.001) {
        return true;
      }
    }

    return false;
  }

  /// 지식 포인트 기반 등급 계산
  ExplorerRank _calculateRank(int points) {
    // 높은 등급부터 체크
    for (final rank in ExplorerRank.values.reversed) {
      final threshold = ProgressionConfig.rankThresholds[rank] ?? 0;
      if (points >= threshold) {
        return rank;
      }
    }
    return ExplorerRank.novice;
  }
}
