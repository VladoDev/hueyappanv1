import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.category,
    required super.isFavorite,
  });

  factory ContactModel.fromFirestore(DocumentSnapshot doc, bool isFavorite) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ContactModel(
      id: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      category: data['category'] ?? '',
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
