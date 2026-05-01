import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String id;
  final String vehicleId;
  final DateTime startTime;
  final DateTime endTime;
  final double startingBid;
  final String status;
  final String? winnerId;
  final double? winningBid;

  Auction({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    required this.endTime,
    required this.startingBid,
    required this.status,
    this.winnerId,
    this.winningBid,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      startTime: json['startTime'] is Timestamp 
          ? (json['startTime'] as Timestamp).toDate() 
          : DateTime.parse(json['startTime'].toString()),
      endTime: json['endTime'] is Timestamp 
          ? (json['endTime'] as Timestamp).toDate() 
          : DateTime.parse(json['endTime'].toString()),
      startingBid: (json['startingBid'] ?? 0).toDouble(),
      status: json['status'] ?? 'DRAFT',
      winnerId: json['winnerId'],
      winningBid: json['winningBid'] != null ? json['winningBid'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'startingBid': startingBid,
      'status': status,
      'winnerId': winnerId,
      'winningBid': winningBid,
    };
  }
}
