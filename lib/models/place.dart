import 'dart:io';

import 'package:f09_recursos_nativos/models/place_location.dart';

class Place {
  final String id;
  final String title;
  final String phone;
  final String email;
  final PlaceLocation? location;
  final File image;

  Place({
    required this.id,
    required this.title,
    required this.phone,
    required this.email,
    this.location,
    required this.image,
  });
}
