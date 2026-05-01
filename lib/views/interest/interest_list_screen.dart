import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/interest_provider.dart';
import '../home/widgets/vehicle_card.dart';

class InterestListScreen extends StatelessWidget {
  const InterestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final interestProvider = context.watch<InterestProvider>();
    final vehicles = interestProvider.interestedVehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest List'),
      ),
      body: vehicles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    'No vehicles in your interest list.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return VehicleCard(vehicle: vehicles[index]);
              },
            ),
    );
  }
}
