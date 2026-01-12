import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/user_progress.dart';

enum CountryUnlockRuleType {
  free,
  eraProgress,
  level,
}

class CountryUnlockRule {
  final CountryUnlockRuleType type;
  final String? eraId;
  final double? requiredProgress;
  final int? requiredLevel;

  const CountryUnlockRule._({
    required this.type,
    this.eraId,
    this.requiredProgress,
    this.requiredLevel,
  });

  const CountryUnlockRule.free() : this._(type: CountryUnlockRuleType.free);

  const CountryUnlockRule.eraProgress(String eraId, double requiredProgress)
      : this._(
          type: CountryUnlockRuleType.eraProgress,
          eraId: eraId,
          requiredProgress: requiredProgress,
        );

  const CountryUnlockRule.level(int requiredLevel)
      : this._(
          type: CountryUnlockRuleType.level,
          requiredLevel: requiredLevel,
        );
}

typedef CountryUnlockRuleResolver = CountryUnlockRule Function(Region region);

class CountryUnlockRules {
  CountryUnlockRules._();

  static CountryUnlockRule? resolve({
    required Country country,
    required Region region,
  }) {
    final direct = _countryRules[country.id];
    if (direct != null) {
      return direct;
    }

    final resolver = _regionRules[region.id];
    return resolver?.call(region);
  }

  static bool canUnlock({
    required UserProgress progress,
    required Country country,
    required Region region,
  }) {
    final rule = resolve(country: country, region: region);
    if (rule == null) {
      return false;
    }

    switch (rule.type) {
      case CountryUnlockRuleType.free:
        return true;
      case CountryUnlockRuleType.eraProgress:
        final eraId = rule.eraId;
        final requiredProgress = rule.requiredProgress;
        if (eraId == null || requiredProgress == null) {
          return false;
        }
        return progress.getEraProgress(eraId) >= requiredProgress - 0.001;
      case CountryUnlockRuleType.level:
        final requiredLevel = rule.requiredLevel ?? 0;
        return _userLevel(progress) >= requiredLevel;
    }
  }

  static String? hintFor({
    required Country country,
    required Region region,
  }) {
    final rule = resolve(country: country, region: region);
    if (rule == null) {
      return _fallbackHint(region);
    }

    switch (rule.type) {
      case CountryUnlockRuleType.free:
        return '기본 해금';
      case CountryUnlockRuleType.eraProgress:
        return _eraProgressHint(rule);
      case CountryUnlockRuleType.level:
        if (rule.requiredLevel == null) {
          return _fallbackHint(region);
        }
        return '탐험가 레벨 ${rule.requiredLevel} 필요';
    }
  }

  static int _userLevel(UserProgress progress) => progress.rank.index * 5;

  static String? _fallbackHint(Region region) {
    if (region.id == 'asia') {
      return '아시아 문명 진행도에 따라 해금';
    }
    if (region.unlockLevel > 0) {
      return '탐험가 레벨 ${region.unlockLevel} 필요';
    }
    return null;
  }

  static String _eraProgressHint(CountryUnlockRule rule) {
    final eraId = rule.eraId ?? '해당 시대';
    final label = _eraLabels[eraId] ?? eraId;
    final progress = rule.requiredProgress ?? 0.0;
    final percent = (progress * 100).round();
    if (percent >= 100) {
      return '$label 완료 시 해금';
    }
    return '$label $percent% 완료 시 해금';
  }

  static const Map<String, String> _eraLabels = {
    'korea_three_kingdoms': '삼국시대',
    'korea_unified_silla': '통일신라',
    'korea_goryeo': '고려시대',
    'korea_joseon': '조선시대',
  };

  static const Map<String, CountryUnlockRule> _countryRules = {
    'korea': CountryUnlockRule.free(),
    'china': CountryUnlockRule.eraProgress('korea_three_kingdoms', 0.3),
    'japan': CountryUnlockRule.eraProgress('korea_three_kingdoms', 0.6),
    'india': CountryUnlockRule.eraProgress('korea_goryeo', 0.3),
    'mongolia': CountryUnlockRule.eraProgress('korea_goryeo', 0.6),
    'greece': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
    'rome': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
    'uk': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
    'britain': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
    'france': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
    'germany': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
    'italy': CountryUnlockRule.eraProgress('korea_three_kingdoms', 1.0),
  };

  static final Map<String, CountryUnlockRuleResolver> _regionRules = {
    'africa': (region) => CountryUnlockRule.level(region.unlockLevel),
    'americas': (region) => CountryUnlockRule.level(region.unlockLevel),
    'middle_east': (region) => CountryUnlockRule.level(region.unlockLevel),
  };
}
