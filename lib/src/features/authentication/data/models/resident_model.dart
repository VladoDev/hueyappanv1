import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/resident_entity.dart';

part 'resident_model.freezed.dart';
part 'resident_model.g.dart';

@freezed
abstract class ResidentModel with _$ResidentModel {
  const factory ResidentModel({
    required String uid,
    required String name,
    required String email,
    required String housingUnit,
    required String accountStatus,
    String? phone,
    String? residentType,
  }) = _ResidentModel;

  factory ResidentModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);

  factory ResidentModel.fromEntity(ResidentEntity entity) => ResidentModel(
        uid: entity.uid,
        name: entity.name,
        email: entity.email,
        housingUnit: entity.housingUnit,
        accountStatus: entity.accountStatus,
        phone: entity.phone,
        residentType: entity.residentType,
      );
}

extension ResidentModelX on ResidentModel {
  ResidentEntity toEntity() => ResidentEntity(
        uid: uid,
        name: name,
        email: email,
        housingUnit: housingUnit,
        accountStatus: accountStatus,
        phone: phone,
        residentType: residentType,
      );
}
