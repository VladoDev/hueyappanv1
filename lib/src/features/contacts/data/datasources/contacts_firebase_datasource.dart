import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../models/contact_model.dart';
import '../../domain/entities/contact_entity.dart';

class ContactsFirebaseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ContactEntity>> getContactsStream() {
    final user = _auth.currentUser;
    
    // Stream of all contacts
    final contactsStream = _firestore.collection('contacts').snapshots().map(
      (snapshot) => snapshot.docs,
    );

    if (user == null) {
      // If no user, return contacts without favorites
      return contactsStream.map(
        (docs) => docs.map((doc) => ContactModel.fromFirestore(doc, false)).toList(),
      );
    }

    // Stream of user's favorite contact IDs
    final favoritesStream = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorite_contacts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());

    // Combine both streams
    return Rx.combineLatest2(
      contactsStream,
      favoritesStream,
      (List<QueryDocumentSnapshot> docs, Set<String> favoriteIds) {
        return docs.map((doc) {
          final isFavorite = favoriteIds.contains(doc.id);
          return ContactModel.fromFirestore(doc, isFavorite);
        }).toList();
      },
    );
  }

  Future<void> toggleFavorite(String contactId, bool isFavorite) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorite_contacts')
        .doc(contactId);

    if (isFavorite) {
      await docRef.set({'addedAt': FieldValue.serverTimestamp()});
    } else {
      await docRef.delete();
    }
  }

  Future<void> addContact(ContactEntity contact) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Must be logged in to add a contact');
    
    // Convert to model to use toFirestore
    final model = ContactModel(
      id: '', // Firestore auto-generates ID
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      category: contact.category,
      isFavorite: false,
    );

    await _firestore.collection('contacts').add(model.toFirestore());
  }
}
