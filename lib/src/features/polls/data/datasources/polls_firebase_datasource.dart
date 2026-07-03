import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/poll_model.dart';
import '../models/revert_vote_request_model.dart';
import '../../../authentication/domain/entities/resident_entity.dart';
import '../../domain/entities/revert_vote_request_entity.dart';

class PollsFirebaseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PollModel>> getPolls() {
    return _firestore
        .collection('polls')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return PollModel.fromJson(data);
            }).toList());
  }

  Future<void> createPoll(PollModel poll) async {
    await _firestore.collection('polls').add({
      'title': poll.title,
      'description': poll.description,
      'options': poll.options.map((o) => {
        'id': o.id,
        'text': o.text,
        'votesCount': o.votesCount,
      }).toList(),
      'votedHouseholds': poll.votedHouseholds,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': poll.createdBy,
      'isActive': poll.isActive,
    });
  }

  Future<void> deletePoll(String pollId) async {
    await _firestore.collection('polls').doc(pollId).delete();
  }

  Future<void> closePoll(String pollId) async {
    await _firestore.collection('polls').doc(pollId).update({'isActive': false});
  }

  Future<void> vote({
    required String pollId,
    required String optionId,
    required ResidentEntity resident,
  }) async {
    final houseId = '${resident.lot}_${resident.house}';
    final pollRef = _firestore.collection('polls').doc(pollId);
    final voteRef = pollRef.collection('votes').doc(houseId);

    await _firestore.runTransaction((transaction) async {
      final pollDoc = await transaction.get(pollRef);
      if (!pollDoc.exists) {
        throw Exception('La votación no existe');
      }

      final data = pollDoc.data()!;
      final votedHouseholds = Map<String, dynamic>.from(data['votedHouseholds'] ?? {});

      if (votedHouseholds.containsKey(houseId)) {
        throw Exception('Tu casa ya ha emitido un voto para esta votación');
      }

      if (data['isActive'] == false) {
        throw Exception('La votación ya está cerrada');
      }

      // Update the option count
      List<dynamic> options = List.from(data['options']);
      int optionIndex = options.indexWhere((opt) => opt['id'] == optionId);
      if (optionIndex == -1) {
        throw Exception('Opción no encontrada');
      }

      options[optionIndex]['votesCount'] = (options[optionIndex]['votesCount'] ?? 0) + 1;
      
      // Add the household to voted map
      votedHouseholds[houseId] = resident.name;

      transaction.update(pollRef, {
        'options': options,
        'votedHouseholds': votedHouseholds,
      });

      transaction.set(voteRef, {
        'userId': resident.uid,
        'userName': resident.name,
        'optionId': optionId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> requestRevertVote({
    required String pollId,
    required String pollTitle,
    required ResidentEntity resident,
    required String previousOptionId,
  }) async {
    final houseId = '${resident.lot}_${resident.house}';
    
    // Check if there is already a pending request
    final existingQuery = await _firestore
        .collection('revert_vote_requests')
        .where('pollId', isEqualTo: pollId)
        .where('houseId', isEqualTo: houseId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (existingQuery.docs.isNotEmpty) {
      throw Exception('Ya tienes una solicitud pendiente para esta votación');
    }

    final newRequest = RevertVoteRequestModel(
      id: '',
      pollId: pollId,
      pollTitle: pollTitle,
      userId: resident.uid,
      userName: resident.name,
      houseId: houseId,
      previousOptionId: previousOptionId,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    final data = newRequest.toJson();
    data.remove('id');
    await _firestore.collection('revert_vote_requests').add(data);
  }

  Stream<List<RevertVoteRequestModel>> getPendingRevertRequests() {
    return _firestore
        .collection('revert_vote_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return RevertVoteRequestModel.fromJson(data);
          }).toList();
          list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return list;
        });
  }

  Future<void> processRevertRequest({
    required RevertVoteRequestEntity request,
    required bool approve,
  }) async {
    final requestRef = _firestore.collection('revert_vote_requests').doc(request.id);

    if (!approve) {
      await requestRef.update({'status': 'rejected'});
      return;
    }

    final pollRef = _firestore.collection('polls').doc(request.pollId);
    final voteRef = pollRef.collection('votes').doc(request.houseId);

    await _firestore.runTransaction((transaction) async {
      final pollDoc = await transaction.get(pollRef);
      if (!pollDoc.exists) return; // If poll was deleted, just mark as approved
      
      final voteDoc = await transaction.get(voteRef);
      
      final data = pollDoc.data()!;
      List<dynamic> options = List.from(data['options']);
      final votedHouseholds = Map<String, dynamic>.from(data['votedHouseholds'] ?? {});

      if (voteDoc.exists) {
        final optionId = voteDoc.data()!['optionId'];
        int optionIndex = options.indexWhere((opt) => opt['id'] == optionId);
        if (optionIndex != -1 && options[optionIndex]['votesCount'] > 0) {
          options[optionIndex]['votesCount'] = options[optionIndex]['votesCount'] - 1;
        }
        transaction.delete(voteRef);
      } else {
        // Fallback to request's previousOptionId if vote sub-doc missing
        int optionIndex = options.indexWhere((opt) => opt['id'] == request.previousOptionId);
        if (optionIndex != -1 && options[optionIndex]['votesCount'] > 0) {
          options[optionIndex]['votesCount'] = options[optionIndex]['votesCount'] - 1;
        }
      }

      votedHouseholds.remove(request.houseId);

      transaction.update(pollRef, {
        'options': options,
        'votedHouseholds': votedHouseholds,
      });

      transaction.update(requestRef, {'status': 'approved'});
    });
  }
}
