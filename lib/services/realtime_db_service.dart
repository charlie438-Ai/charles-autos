import 'package:firebase_database/firebase_database.dart';
import '../models/bid.dart';

class RealtimeDbService {
  FirebaseDatabase get _db {
    try {
      return FirebaseDatabase.instance;
    } catch (e) {
      throw Exception('Realtime DB not initialized.');
    }
  }

  // Stream of bids for a specific auction
  Stream<List<Bid>> streamBids(String auctionId) {
    return _db.ref('live_bids/$auctionId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((e) {
        final bidData = Map<String, dynamic>.from(e.value as Map);
        return Bid.fromJson(bidData..['id'] = e.key);
      }).toList()..sort((a, b) => b.amount.compareTo(a.amount)); // Sort highest first
    });
  }

  // Place a bid
  Future<void> placeBid(String auctionId, Bid bid) async {
    final ref = _db.ref('live_bids/$auctionId').push();
    await ref.set(bid.toJson());
  }

  // Get current highest bid
  Future<Bid?> getHighestBid(String auctionId) async {
    final snapshot = await _db.ref('live_bids/$auctionId').orderByChild('amount').limitToLast(1).get();
    if (!snapshot.exists) return null;
    
    final data = snapshot.children.first.value as Map<dynamic, dynamic>;
    return Bid.fromJson(Map<String, dynamic>.from(data)..['id'] = snapshot.children.first.key);
  }
}
