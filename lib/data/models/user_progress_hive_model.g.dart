// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressHiveModelAdapter extends TypeAdapter<UserProgressHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserProgressHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgressHiveModel(
      userId: fields[0] as String,
      totalKnowledge: fields[1] as int,
      rankIndex: fields[2] as int,
      regionProgress: (fields[3] as Map?)?.cast<String, double>(),
      countryProgress: (fields[4] as Map?)?.cast<String, double>(),
      eraProgress: (fields[5] as Map?)?.cast<String, double>(),
      completedDialogueIds: (fields[6] as List?)?.cast<String>(),
      unlockedRegionIds: (fields[7] as List?)?.cast<String>(),
      unlockedCountryIds: (fields[8] as List?)?.cast<String>(),
      unlockedEraIds: (fields[9] as List?)?.cast<String>(),
      unlockedCharacterIds: (fields[10] as List?)?.cast<String>(),
      unlockedFactIds: (fields[11] as List?)?.cast<String>(),
      achievementIds: (fields[12] as List?)?.cast<String>(),
      completedQuizIds: (fields[13] as List?)?.cast<String>(),
      discoveredEncyclopediaIds: (fields[14] as List?)?.cast<String>(),
      lastPlayedAt: fields[15] as DateTime?,
      lastPlayedEraId: fields[16] as String?,
      totalPlayTimeMinutes: fields[17] as int,
      loginStreak: fields[18] as int,
      coins: fields[19] as int,
      inventoryIds: (fields[20] as List?)?.cast<String>(),
      hasCompletedTutorial: fields[21] as bool,
      encyclopediaDiscoveryDatesMs: (fields[22] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgressHiveModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.totalKnowledge)
      ..writeByte(2)
      ..write(obj.rankIndex)
      ..writeByte(3)
      ..write(obj.regionProgress)
      ..writeByte(4)
      ..write(obj.countryProgress)
      ..writeByte(5)
      ..write(obj.eraProgress)
      ..writeByte(6)
      ..write(obj.completedDialogueIds)
      ..writeByte(7)
      ..write(obj.unlockedRegionIds)
      ..writeByte(8)
      ..write(obj.unlockedCountryIds)
      ..writeByte(9)
      ..write(obj.unlockedEraIds)
      ..writeByte(10)
      ..write(obj.unlockedCharacterIds)
      ..writeByte(11)
      ..write(obj.unlockedFactIds)
      ..writeByte(12)
      ..write(obj.achievementIds)
      ..writeByte(13)
      ..write(obj.completedQuizIds)
      ..writeByte(14)
      ..write(obj.discoveredEncyclopediaIds)
      ..writeByte(15)
      ..write(obj.lastPlayedAt)
      ..writeByte(16)
      ..write(obj.lastPlayedEraId)
      ..writeByte(17)
      ..write(obj.totalPlayTimeMinutes)
      ..writeByte(18)
      ..write(obj.loginStreak)
      ..writeByte(19)
      ..write(obj.coins)
      ..writeByte(20)
      ..write(obj.inventoryIds)
      ..writeByte(21)
      ..write(obj.hasCompletedTutorial)
      ..writeByte(22)
      ..write(obj.encyclopediaDiscoveryDatesMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
