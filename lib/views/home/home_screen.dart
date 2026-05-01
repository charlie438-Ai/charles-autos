import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../services/mock_database.dart';
import '../contact/location_contact_screen.dart';
import '../interest/interest_list_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/compare_viewmodel.dart';
import '../comparison/comparison_screen.dart';
import 'widgets/vehicle_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String searchQuery = '';
  List<Vehicle> filteredVehicles = MockDatabase.vehicles;

  final List<Widget> _screens = [
    const HomeContent(),
    const InterestListScreen(),
    const LocationContactScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Interest'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Contact'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String searchQuery = '';
  String selectedCategory = 'All';
  List<Vehicle> filteredVehicles = MockDatabase.vehicles;

  void _updateSearch(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  void _setCategory(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredVehicles = MockDatabase.vehicles.where((v) {
      final matchesQuery = v.make.toLowerCase().contains(searchQuery.toLowerCase()) ||
          v.model.toLowerCase().contains(searchQuery.toLowerCase());
          
      bool matchesCategory = true;
      if (selectedCategory != 'All') {
        if (selectedCategory == 'Salvage') {
          matchesCategory = v.condition.toUpperCase() == 'SALVAGE';
        } else if (selectedCategory == 'SUVs') {
          matchesCategory = ['rx 350', 'rav4', 'cr-v'].contains(v.model.toLowerCase());
        } else if (selectedCategory == 'Sedans') {
          matchesCategory = ['camry', 'corolla', 'accord'].contains(v.model.toLowerCase());
        } else if (selectedCategory == 'Trucks') {
          matchesCategory = ['f-150', 'silverado', 'tacoma'].contains(v.model.toLowerCase());
        }
      }
      
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final compareVM = context.watch<CompareViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charles Autos'),
        actions: [
          IconButton(
            icon: Icon(compareVM.isCompareMode ? Icons.compare_arrows : Icons.compare),
            color: compareVM.isCompareMode ? Theme.of(context).primaryColor : Colors.white,
            onPressed: () {
              compareVM.toggleCompareMode();
            },
          ),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _updateSearch,
              decoration: InputDecoration(
                hintText: 'Search make, model...',
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'SUVs', 'Sedans', 'Trucks', 'Salvage']
                  .map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (val) {
                            if (val) _setCategory(cat);
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Vehicle List
          Expanded(
            child: filteredVehicles.isEmpty 
              ? const Center(child: Text('No vehicles found'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = filteredVehicles[index];
                    return VehicleCard(vehicle: vehicle);
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: compareVM.isCompareMode 
          ? FloatingActionButton.extended(
              onPressed: compareVM.canCompare 
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComparisonScreen(),
                        ),
                      );
                    } 
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Select at least 2 vehicles to compare')),
                      );
                    },
              label: Text('Compare (${compareVM.selectedVehicles.length})', style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.compare_arrows, color: Colors.white),
              backgroundColor: compareVM.canCompare ? Theme.of(context).primaryColor : Colors.grey,
            )
          : null,
    );
  }
}
