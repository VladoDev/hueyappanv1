filepath = 'lib/src/features/contacts/data/datasources/contacts_firebase_datasource.dart'

with open(filepath, 'r') as f:
    content = f.read()

new_method = """
  Future<void> deleteContact(String contactId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Must be logged in to delete a contact');
    
    // Admins only: We rely on security rules or UI, but here we just delete it from contacts
    await _firestore.collection('contacts').doc(contactId).delete();
  }
}
"""

content = content.replace("  }\n}\n", "  }\n" + new_method)

with open(filepath, 'w') as f:
    f.write(content)

print("Added deleteContact to DS")
