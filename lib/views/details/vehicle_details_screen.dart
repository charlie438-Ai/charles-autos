import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle.dart';
import '../../models/auction.dart';
import '../../services/mock_database.dart';
import '../../viewmodels/interest_provider.dart';
import '../../viewmodels/auction_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/message.dart';
import 'widgets/payment_options_sheet.dart';
import 'widgets/currency_converter.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  bool isRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuctionViewModel>().subscribeToAuction(widget.vehicle.id);
    });
  }

  void _handleRequest() {
    setState(() {
      isRequested = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test drive request sent successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              Consumer<InterestProvider>(
                builder: (context, provider, _) {
                  final isFav = provider.isInterested(widget.vehicle.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () => provider.toggleInterest(widget.vehicle),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'vehicle-${widget.vehicle.id}',
                child: widget.vehicle.photos.isNotEmpty
                  ? (widget.vehicle.photos[0].startsWith('http')
                      ? Image.network(
                          widget.vehicle.photos[0],
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.vehicle.photos[0]),
                          fit: BoxFit.cover,
                        ))
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.directions_car, size: 80, color: Colors.white54),
                    ),
              ),
            ),
          ),

          // Details List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.vehicle.year} ${widget.vehicle.make}',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                          ),
                          Text(
                            widget.vehicle.model,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.vehicle.price.toInt()}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Currency Converter
                  CurrencyConverter(basePriceUSD: widget.vehicle.price),
                  
                  const SizedBox(height: 24),
                  
                  // Spec Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: [
                      _buildSpecItem(Icons.speed, 'Mileage', '${widget.vehicle.mileage} mi'),
                      _buildSpecItem(Icons.confirmation_number_outlined, 'VIN', widget.vehicle.vin.substring(0, 8) + '...'),
                      _buildSpecItem(Icons.car_repair, 'Condition', widget.vehicle.condition),
                      _buildSpecItem(Icons.calendar_today, 'Year', widget.vehicle.year.toString()),
                    ],
                  ),

                  const SizedBox(height: 32),
                  
                  // Auction Section (If active)
                  _buildAuctionSection(),
                  
                  const SizedBox(height: 32),
                  Text('Damage Report', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    widget.vehicle.damageReport,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Interactive Button (Stateful Requirement)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showMessageDealerDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text(
                            'Message Dealer',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => PaymentOptionsSheet(amount: widget.vehicle.price),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageDealerDialog(BuildContext context) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Charles Autos'),
        content: TextField(
          controller: messageController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'I am interested in this vehicle...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                final authVM = context.read<AuthViewModel>();
                MockDatabase.addMessage(Message(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  vehicleId: widget.vehicle.id,
                  senderName: authVM.user?.email ?? 'Guest User',
                  senderEmail: authVM.user?.email ?? 'guest@example.com',
                  senderPhone: 'N/A',
                  content: messageController.text,
                  timestamp: DateTime.now(),
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent successfully!')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionSection() {
    final auction = MockDatabase.auctions.firstWhere(
      (a) => a.vehicleId == widget.vehicle.id,
      orElse: () => Auction(id: '', vehicleId: '', startTime: DateTime.now(), endTime: DateTime.now(), startingBid: 0, status: 'NONE'),
    );

    if (auction.status == 'NONE') return const SizedBox.shrink();

    return Consumer2<AuctionViewModel, AuthViewModel>(
      builder: (context, auctionVM, authVM, _) {
        final currentBid = auctionVM.getCurrentHighestBid(auction.id, auction.startingBid);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('LIVE AUCTION', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                    child: const Text('01:24:05', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Current Bid:', style: TextStyle(color: Colors.white70)),
                  Text('\$${currentBid.toInt()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: authVM.isAuthenticated ? () {} : null,
                      child: const Text('Place Proxy Bid'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: authVM.isAuthenticated 
                          ? () => auctionVM.placeBid(
                              auction.id, 
                              authVM.user?.uid ?? 'mock-user-id', 
                              currentBid + 500
                            )
                          : null,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: Text('Bid \$${(currentBid + 500).toInt()}'),
                    ),
                  ),
                ],
              ),
              if (!authVM.isAuthenticated)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text('Sign in to place a bid', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
