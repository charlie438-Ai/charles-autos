import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle.dart';
import '../../viewmodels/compare_viewmodel.dart';
import '../details/vehicle_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final compareVM = context.watch<CompareViewModel>();
    final vehicles = compareVM.selectedVehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Vehicles'),
        elevation: 0,
      ),
      body: vehicles.isEmpty
          ? const Center(child: Text('No vehicles selected for comparison.'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return _buildComparisonCard(context, vehicle, compareVM);
              },
            ),
    );
  }

  Widget _buildComparisonCard(BuildContext context, Vehicle vehicle, CompareViewModel compareVM) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to vehicle details
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicle: vehicle)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image with Remove Button
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: vehicle.photos.isNotEmpty ? vehicle.photos.first : '',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error, size: 50),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.white, size: 30),
                        onPressed: () {
                          compareVM.toggleVehicle(vehicle);
                          if (compareVM.selectedVehicles.isEmpty) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\$${vehicle.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Specs List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text('${vehicle.year} ${vehicle.make} ${vehicle.model}', 
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildSpecRow(context, Icons.speed, 'Mileage', '${vehicle.mileage} mi'),
                      _buildSpecRow(context, Icons.verified, 'Condition', vehicle.condition),
                      _buildSpecRow(context, Icons.build, 'Damage Report', vehicle.damageReport),
                      _buildSpecRow(context, Icons.numbers, 'VIN', vehicle.vin),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.info_outline),
                        label: const Text('View Full Details'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicle: vehicle)),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
