import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/vehicle.dart';
import '../../../viewmodels/interest_provider.dart';
import '../../../viewmodels/compare_viewmodel.dart';
import '../../details/vehicle_details_screen.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final compareVM = context.watch<CompareViewModel>();
    final isCompareMode = compareVM.isCompareMode;
    final isSelected = compareVM.isSelected(vehicle.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardTheme.color,
        border: isCompareMode && isSelected 
            ? Border.all(color: Theme.of(context).primaryColor, width: 3) 
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isCompareMode) {
                compareVM.toggleVehicle(vehicle);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailsScreen(vehicle: vehicle),
                  ),
                );
              }
            },
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Condition Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Hero(
                    tag: 'vehicle-${vehicle.id}',
                    child: vehicle.photos.isNotEmpty 
                        ? (vehicle.photos[0].startsWith('http')
                            ? Image.network(
                                vehicle.photos[0],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(vehicle.photos[0]),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ))
                        : Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[800],
                            child: const Icon(Icons.directions_car, size: 50, color: Colors.white54),
                          ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Consumer<InterestProvider>(
                    builder: (context, provider, _) {
                      final isFav = provider.isInterested(vehicle.id);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () => provider.toggleInterest(vehicle),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: vehicle.condition == 'CLEAN' ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vehicle.condition,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${vehicle.year} ${vehicle.make} ${vehicle.model}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        currencyFormatter.format(vehicle.price),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.speed, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('${vehicle.mileage} miles', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      const Text('Showroom A', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
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
}
