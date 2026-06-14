import '../entities/water_status_entity.dart';

abstract class WaterStatusRepository {
  Stream<WaterStatusEntity> watchWaterStatus();
  Future<void> updateWaterStatus(String status, String uid);
}
