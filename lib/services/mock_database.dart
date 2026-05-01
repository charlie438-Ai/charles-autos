import '../models/vehicle.dart';
import '../models/auction.dart';
import '../models/message.dart';

class MockDatabase {
  static List<Vehicle> vehicles = [
    Vehicle(
      id: 'v1',
      sellerId: 's1',
      vin: '1HGCM82635A000001',
      make: 'Toyota',
      model: 'Camry',
      year: 2022,
      mileage: 15000,
      price: 25000,
      condition: 'CLEAN',
      damageReport: 'No major damage. Minor scratches on bumper.',
      status: 'Available',
      photos: [
        'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?q=80&w=1000&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1617469767053-d3b508a0d182?q=80&w=1000&auto=format&fit=crop',
      ],
    ),
    Vehicle(
      id: 'v2',
      sellerId: 's1',
      vin: 'JTEBU1JR4L5000002',
      make: 'Lexus',
      model: 'RX 350',
      year: 2021,
      mileage: 30000,
      price: 42000,
      condition: 'SALVAGE',
      damageReport: 'Front-end collision. Airbags deployed. Engine intact.',
      status: 'Available',
      photos: [
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=1000&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1583121274602-3e2820c69888?q=80&w=1000&auto=format&fit=crop',
      ],
    ),
    Vehicle(
      id: 'v3',
      sellerId: 's2',
      vin: '1FTFX1EF5LFA00003',
      make: 'Ford',
      model: 'F-150',
      year: 2023,
      mileage: 5000,
      price: 55000,
      condition: 'CLEAN',
      damageReport: 'Like new. Used for showroom demo.',
      status: 'Sold',
      photos: [
        'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=1000&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?q=80&w=1000&auto=format&fit=crop',
      ],
    ),
  ];

  static List<Message> messages = [];

  static void addVehicle(Vehicle vehicle) {
    vehicles.add(vehicle);
  }

  static void updateVehicle(Vehicle updatedVehicle) {
    final index = vehicles.indexWhere((v) => v.id == updatedVehicle.id);
    if (index != -1) {
      vehicles[index] = updatedVehicle;
    }
  }

  static void addMessage(Message message) {
    messages.add(message);
  }

  static List<Auction> auctions = [
    Auction(
      id: 'a1',
      vehicleId: 'v2',
      startTime: DateTime.now().subtract(Duration(hours: 1)),
      endTime: DateTime.now().add(Duration(hours: 2)),
      startingBid: 15000,
      status: 'ACTIVE',
    ),
    Auction(
      id: 'a2',
      vehicleId: 'v1',
      startTime: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1, hours: 4)),
      startingBid: 20000,
      status: 'UPCOMING',
    ),
  ];
}
