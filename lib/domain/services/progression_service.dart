import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
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
  /// 등급별 해금 항목 (PRD 기반)
  static const Map<ExplorerRank, List<String>> rankUnlocks = {
    ExplorerRank.apprentice: ['region_europe', 'feature_hint'],
    ExplorerRank.intermediate: ['region_africa', 'feature_quiz'],
    ExplorerRank.advanced: ['region_america', 'feature_timeline'],
    ExplorerRank.expert: ['region_middle_east', 'feature_whatif'],
    ExplorerRank.master: ['era_hidden', 'title_master'],
  };
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
        
        // 등급별 해금 항목 확인
        final unlocks = rankUnlocks[newRank] ?? [];
        for (final unlockId in unlocks) {
          // 지역 해금
          if (unlockId.startsWith('region_')) {
            final regionId = unlockId.replaceFirst('region_', '');
            events.add(UnlockEvent(
              type: UnlockType.region,
              id: regionId,
              name: _getRegionName(regionId),
              message: '${_getRegionName(regionId)} 지역이 해금되었습니다!',
            ));
          }
          // 기능 해금
          else if (unlockId.startsWith('feature_')) {
            final featureName = unlockId.replaceFirst('feature_', '');
            events.add(UnlockEvent(
              type: UnlockType.feature,
              id: unlockId,
              name: _getFeatureName(featureName),
              message: '${_getFeatureName(featureName)} 기능이 해금되었습니다!',
            ));
          }
          // 기타 해금
          else {
            events.add(UnlockEvent(
              type: UnlockType.feature,
              id: unlockId,
              name: unlockId,
              message: '새로운 콘텐츠가 해금되었습니다!',
            ));
          }
        }
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
  
  /// 시대 진행률 계산
  /// 
  /// 완료한 대화 수를 기반으로 진행률을 계산합니다.
  /// 향후 확장: 인물 완료율, 장소 탐험율 등 가중치 적용 가능
  double calculateEraProgress(
    String eraId,
    UserProgress progress,
    List<Dialogue> eraDialogues,
  ) {
    if (eraDialogues.isEmpty) return 0.0;
    
    // 완료한 대화 수
    final completedCount = eraDialogues
        .where((d) => progress.isDialogueCompleted(d.id))
        .length;
    
    // 총 대화 수
    final totalCount = eraDialogues.length;
    
    if (totalCount == 0) return 0.0;
    
    // 기본 진행률 (대화 완료율)
    final dialogueProgress = completedCount / totalCount;
    
    // 향후 확장 가능한 가중치:
    // - 대화 완료: 60%
    // - 인물 완료: 30%
    // - 장소 탐험: 10%
    // 현재는 대화 완료율만 사용
    
    return dialogueProgress.clamp(0.0, 1.0);
  }
  
  /// 지역 진행률 계산
  /// 
  /// 해당 지역의 모든 시대 진행률의 평균을 계산합니다.
  double calculateRegionProgress(
    String regionId,
    UserProgress progress,
    List<Era> regionEras,
  ) {
    if (regionEras.isEmpty) return 0.0;
    
    // 각 시대의 진행률을 가져와서 평균 계산
    // 주의: 실제 진행률은 calculateEraProgress를 통해 계산되어야 함
    // 여기서는 progress에 저장된 값을 사용
    final eraProgresses = regionEras
        .map((era) => progress.getEraProgress(era.id))
        .where((p) => p > 0.0) // 진행한 시대만 포함
        .toList();
    
    if (eraProgresses.isEmpty) return 0.0;
    
    final average = eraProgresses.fold(0.0, (sum, p) => sum + p) / eraProgresses.length;
    return average.clamp(0.0, 1.0);
  }
  
  /// 지역 이름 가져오기 (헬퍼 메서드)
  String _getRegionName(String regionId) {
    const regionNames = {
      'europe': '유럽',
      'africa': '아프리카',
      'america': '아메리카',
      'middle_east': '중동',
    };
    return regionNames[regionId] ?? regionId;
  }
  
  /// 기능 이름 가져오기 (헬퍼 메서드)
  String _getFeatureName(String featureId) {
    const featureNames = {
      'hint': '힌트 기능',
      'quiz': '퀴즈 모드',
      'timeline': '타임라인 비교',
      'whatif': '역사 What-If 모드',
    };
    return featureNames[featureId] ?? featureId;
  }
}
