// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String title;
  final String phone;
  final String email;
  final String imagePath;
  final String address;
  final double latitude;
  final double longitude;

  const PlaceDetailScreen({
    super.key,
    required this.title,
    required this.phone,
    required this.email,
    required this.imagePath,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Função para abrir o app de chamadas
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(phoneUri)) {
      throw 'Não foi possível fazer a chamada para $phoneNumber';
    }
  }

  // Função para abrir o app de envio de e-mails
  Future<void> _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (!await launchUrl(emailUri)) {
      throw 'Não foi possível enviar um e-mail para $emailAddress';
    }
  }

  // Função para abrir o app de navegação (Google Maps, Waze, etc.)
  Future<void> _openMap(double latitude, double longitude) async {
    final Uri googleMapsUri = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    final Uri wazeUri = Uri.parse('https://waze.com/ul?ll=$latitude,$longitude&navigate=yes');

    // Tenta abrir primeiro no Google Maps, se falhar tenta no Waze
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(wazeUri)) {
      await launchUrl(wazeUri);
    } else {
      throw 'Não foi possível abrir um aplicativo de navegação';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.edit, color: Colors.grey,),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do lugar
            Image.file(
              File(imagePath),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Número de telefone
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone),
              onTap: () => _makePhoneCall(phone), // Abre o app de chamadas
            ),

            // Email
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              onTap: () => _sendEmail(email), // Abre o app de e-mails
            ),

            // Endereço
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Endereço:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                address,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                _openMap(latitude, longitude); // Abre o app de navegação
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&markers=color:red|$latitude,$longitude&key=AIzaSyBsOM8M5gS3h17pCJtnUY5FkzIlj2GZTY0',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 2,
                  minimumSize: Size.fromHeight(40),
                ),
                child: const Text(
                  'Delete', 
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
