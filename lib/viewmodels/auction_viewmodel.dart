import 'package:flutter/material.dart';
import '../models/bid.dart';
import '../services/realtime_db_service.dart';

class AuctionViewModel with ChangeNotifier {
  final RealtimeDbService _dbService = RealtimeDbService();
  final Map<String, List<Bid>> _bidsCache = {};

  List<Bid> getBids(String auctionId) => _bidsCache[auctionId] ?? [];

  void subscribeToAuction(String auctionId) {
    try {
      _dbService.streamBids(auctionId).listen((bids) {
        _bidsCache[auctionId] = bids;
        notifyListeners();
      });
    } catch (e) {
      print('AuctionViewModel: Realtime DB not available.');
    }
  }

  Future<void> placeBid(String auctionId, String userId, double amount) async {
    final bid = Bid(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      auctionId: auctionId,
      bidderId: userId, 
      amount: amount, 
      timestamp: DateTime.now()
    );
    
    try {
      await _dbService.placeBid(auctionId, bid);
    } catch (e) {
      // Mock Bidding: Update local cache
      final currentBids = _bidsCache[auctionId] ?? [];
      currentBids.insert(0, bid); // Add to top
      _bidsCache[auctionId] = currentBids;
      notifyListeners();
      print('Mock bid placed: $amount');
    }
  }

  double getCurrentHighestBid(String auctionId, double startingBid) {
    final bids = getBids(auctionId);
    if (bids.isEmpty) return startingBid;
    return bids.first.amount;
  }
}
