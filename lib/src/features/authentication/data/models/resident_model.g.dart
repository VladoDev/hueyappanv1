// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    _ResidentModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      lot: json['lot'] as String? ?? '',
      house: json['house'] as String? ?? '',
      accountStatus: json['accountStatus'] as String,
      phone: json['phone'] as String?,
      residentType: json['residentType'] as String?,
      role: json['role'] as String? ?? 'vecino',
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$ResidentModelToJson(_ResidentModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'lot': instance.lot,
      'house': instance.house,
      'accountStatus': instance.accountStatus,
      'phone': instance.phone,
      'residentType': instance.residentType,
      'role': instance.role,
      'isPhoneVerified': instance.isPhoneVerified,
    };
