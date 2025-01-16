// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:f09_recursos_nativos/models/place_location.dart';
import 'package:f09_recursos_nativos/utils/geocode_util.dart';
import 'package:flutter/material.dart';

class AddressInputScreen extends StatefulWidget {

  final Function onSelectMap;
  AddressInputScreen(this.onSelectMap);

  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final _addressController = TextEditingController();
  String? _latitude;
  String? _longitude;

  final GeocodingService _geocodingService = GeocodingService();

  void _saveAddress() async {
    final enteredAddress = _addressController.text;

    if (enteredAddress.isEmpty) {
      return;
    }
    Navigator.of(context).pop(enteredAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digite o Endereço', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Endereço',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAddress,
              child: Text('Adicionar Endereço'),
            ),
          ],
        ),
      ),
    );
  }
}
