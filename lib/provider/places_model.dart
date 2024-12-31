import 'dart:io';
import 'dart:math';

import 'package:f09_recursos_nativos/models/place_location.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';
import '../utils/db_util.dart';

class PlacesModel with ChangeNotifier {
  List<Place> _items = [];


  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  void addPlace(String title, String phone, String email, File img) {
    final newPlace = Place(
        id: Random().nextDouble().toString(),
        title: title,
        phone: phone,
        email: email,
        location: null,
        image: img);

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'phone': newPlace.phone,
      'email': newPlace.email,
      'image': newPlace.image.path,
    });
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            phone: item['phone'],
            email: item['email'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: 0.0,
              longitude: 0.0,
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
