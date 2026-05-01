import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';
import '../models/auction.dart';

class FirestoreService {
  FirebaseFirestore get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      throw Exception('Firestore not initialized.');
    }
  }

  // Get all vehicles
  Stream<List<Vehicle>> streamVehicles() {
    return _db.collection('vehicles').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Vehicle.fromJson(doc.data()..['id'] = doc.id)).toList());
  }

  // Get all active auctions
  Stream<List<Auction>> streamActiveAuctions() {
    return _db
        .collection('auctions')
        .where('status', isEqualTo: 'ACTIVE')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Auction.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }

  // Add a vehicle (for Dealers)
  Future<void> addVehicle(Vehicle vehicle) {
    return _db.collection('vehicles').add(vehicle.toJson());
  }

  // Start an auction
  Future<void> createAuction(Auction auction) {
    return _db.collection('auctions').add(auction.toJson());
  }
}
