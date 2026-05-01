class Bid {
  final String id;
  final String auctionId;
  final String bidderId;
  final double amount;
  final bool isProxy;
  final DateTime timestamp;

  Bid({
    required this.id,
    required this.auctionId,
    required this.bidderId,
    required this.amount,
    this.isProxy = false,
    required this.timestamp,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] ?? '',
      auctionId: json['auctionId'] ?? '',
      bidderId: json['bidderId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isProxy: json['isProxy'] ?? false,
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auctionId': auctionId,
      'bidderId': bidderId,
      'amount': amount,
      'isProxy': isProxy,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
