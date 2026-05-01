import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/vehicle.dart';
import '../../services/mock_database.dart';

class AddEditCarScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const AddEditCarScreen({super.key, this.vehicle});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _mileageController;
  late TextEditingController _conditionController;
  late TextEditingController _statusController;
  
  List<String> _photos = [];

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController(text: widget.vehicle?.make ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _yearController = TextEditingController(text: widget.vehicle?.year.toString() ?? '');
    _priceController = TextEditingController(text: widget.vehicle?.price.toString() ?? '');
    _mileageController = TextEditingController(text: widget.vehicle?.mileage.toString() ?? '');
    _conditionController = TextEditingController(text: widget.vehicle?.condition ?? 'CLEAN');
    _statusController = TextEditingController(text: widget.vehicle?.status ?? 'Available');
    _photos = widget.vehicle?.photos.toList() ?? [];
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _conditionController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _photos.addAll(images.map((img) => img.path));
      });
    }
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      final newVehicle = Vehicle(
        id: widget.vehicle?.id ?? 'v${DateTime.now().millisecondsSinceEpoch}',
        sellerId: widget.vehicle?.sellerId ?? 'ADMIN',
        vin: widget.vehicle?.vin ?? 'PENDING',
        make: _makeController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        mileage: int.parse(_mileageController.text),
        price: double.parse(_priceController.text),
        condition: _conditionController.text,
        damageReport: widget.vehicle?.damageReport ?? 'None',
        status: _statusController.text,
        photos: _photos.isEmpty 
          ? ['https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=1000&auto=format&fit=crop'] 
          : _photos,
      );

      if (widget.vehicle == null) {
        MockDatabase.addVehicle(newVehicle);
      } else {
        MockDatabase.updateVehicle(newVehicle);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Add New Car' : 'Edit Car'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveVehicle,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _makeController,
                decoration: const InputDecoration(labelText: 'Make (e.g., Toyota)'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model (e.g., Camry)'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (\$)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Mileage'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _statusController.text.isNotEmpty ? _statusController.text : 'Available',
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Available', 'Sold'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _statusController.text = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              
              // Photos Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Add Photos'),
                  )
                ],
              ),
              if (_photos.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      final photoPath = _photos[index];
                      final isNetwork = photoPath.startsWith('http');
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8, top: 8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: isNetwork 
                                  ? NetworkImage(photoPath) as ImageProvider 
                                  : FileImage(File(photoPath)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _photos.removeAt(index);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveVehicle,
                child: const Text('Save Vehicle'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
