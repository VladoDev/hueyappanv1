import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/bank_details_entity.dart';
import '../../../../core/utils/encryption_service.dart';

class BankDetailsDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<BankDetailsEntity> getBankDetailsStream() {
    return _firestore
        .collection('app_settings')
        .doc('bank_details')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return BankDetailsEntity.empty();
      }
      final data = snapshot.data()!;
      
      // Decrypt data
      return BankDetailsEntity(
        bankName: EncryptionService.decryptData(data['bankName'] as String? ?? ''),
        accountName: EncryptionService.decryptData(data['accountName'] as String? ?? ''),
        clabe: EncryptionService.decryptData(data['clabe'] as String? ?? ''),
        reference: EncryptionService.decryptData(data['reference'] as String? ?? ''),
      );
    });
  }

  Future<void> updateBankDetails(BankDetailsEntity details) async {
    // Encrypt data before saving
    final encryptedData = {
      'bankName': EncryptionService.encryptData(details.bankName),
      'accountName': EncryptionService.encryptData(details.accountName),
      'clabe': EncryptionService.encryptData(details.clabe),
      'reference': EncryptionService.encryptData(details.reference),
    };

    await _firestore
        .collection('app_settings')
        .doc('bank_details')
        .set(encryptedData, SetOptions(merge: true));
  }
}
