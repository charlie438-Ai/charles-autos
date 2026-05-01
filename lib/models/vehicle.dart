class Vehicle {
  final String id;
  final String sellerId;
  final String vin;
  final String make;
  final String model;
  final int year;
  final int mileage;
  final double price;
  final String condition;
  final String damageReport;
  final List<String> photos;
  final String status;

  Vehicle({
    required this.id,
    required this.sellerId,
    required this.vin,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.price,
    required this.condition,
    required this.damageReport,
    required this.photos,
    this.status = 'Available',
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      vin: json['vin'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      mileage: json['mileage'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      condition: json['condition'] ?? '',
      damageReport: json['damageReport'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      status: json['status'] ?? 'Available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'vin': vin,
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
      'price': price,
      'condition': condition,
      'damageReport': damageReport,
      'photos': photos,
      'status': status,
    };
  }
}
