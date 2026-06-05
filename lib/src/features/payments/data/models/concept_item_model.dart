import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/concept_item_entity.dart';

part 'concept_item_model.freezed.dart';
part 'concept_item_model.g.dart';

@freezed
abstract class ConceptItemModel with _$ConceptItemModel {
  const factory ConceptItemModel({
    required String id,
    required String conceptId,
    required String label,
    double? amount,
    required int order,
  }) = _ConceptItemModel;

  factory ConceptItemModel.fromJson(Map<String, dynamic> json) =>
      _$ConceptItemModelFromJson(json);

  factory ConceptItemModel.fromEntity(ConceptItemEntity entity) =>
      ConceptItemModel(
        id: entity.id,
        conceptId: entity.conceptId,
        label: entity.label,
        amount: entity.amount,
        order: entity.order,
      );
}

extension ConceptItemModelX on ConceptItemModel {
  ConceptItemEntity toEntity() => ConceptItemEntity(
        id: id,
        conceptId: conceptId,
        label: label,
        amount: amount,
        order: order,
      );
}
