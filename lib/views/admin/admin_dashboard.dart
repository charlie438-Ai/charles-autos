import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../services/mock_database.dart';
import 'add_edit_car_screen.dart';
import 'inbox_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminInventoryScreen(),
      const InboxScreen(),
      const AdminSettingsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    final vehicles = MockDatabase.vehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditCarScreen(),
                ),
              );
              setState(() {}); // Refresh list
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return ListTile(
            leading: vehicle.photos.isNotEmpty
                ? (vehicle.photos.first.startsWith('http')
                    ? Image.network(vehicle.photos.first, width: 60, height: 60, fit: BoxFit.cover)
                    : Image.file(File(vehicle.photos.first), width: 60, height: 60, fit: BoxFit.cover))
                : const Icon(Icons.car_rental),
            title: Text('${vehicle.year} ${vehicle.make} ${vehicle.model}'),
            subtitle: Text('\$${vehicle.price} • Status: ${vehicle.status}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditCarScreen(vehicle: vehicle),
                  ),
                );
                setState(() {}); // Refresh list
              },
            ),
          );
        },
      ),
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Settings')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            authViewModel.logout();
          },
          child: const Text('Logout as Admin'),
        ),
      ),
    );
  }
}
