import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/water_status_entity.dart';
import '../../domain/repositories/water_status_repository.dart';
import '../datasources/water_status_firebase_datasource.dart';

class WaterStatusRepositoryImpl implements WaterStatusRepository {
  final WaterStatusFirebaseDatasource _datasource;

  WaterStatusRepositoryImpl(this._datasource);

  @override
  Stream<WaterStatusEntity> watchWaterStatus() {
    return _datasource.watchWaterStatus().map((data) {
      final status = data['status'] as String? ?? 'auto';
      final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();
      final updatedBy = data['updatedBy'] as String?;

      return WaterStatusEntity(
        status: status,
        updatedAt: updatedAt,
        updatedBy: updatedBy,
      );
    });
  }

  @override
  Future<void> updateWaterStatus(String status, String uid) {
    return _datasource.updateWaterStatus(status, uid);
  }
}
