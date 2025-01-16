// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, depend_on_referenced_packages, prefer_const_constructors, avoid_print, unnecessary_null_comparison

import 'package:f09_recursos_nativos/models/place_location.dart';
import 'package:f09_recursos_nativos/screens/address_input.dart';
import 'package:f09_recursos_nativos/utils/geocode_util.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/map_screen.dart';
import '../utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectMap;
  LocationInput(this.onSelectMap);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  final GeocodingService _geocodingService = GeocodingService();

  Future<void> _getCurrentUserLocation() async {
    final locData =
        await Location().getLocation(); //pega localização do usuário

    widget.onSelectMap(PlaceLocation(latitude: locData.latitude!, longitude: locData.longitude!));

    print(locData.latitude);
    print(locData.longitude);

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: locData.latitude, longitude: locData.longitude);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true, builder: ((context) => MapScreen())),
    );

    if (selectedPosition == null) return;

    widget.onSelectMap(PlaceLocation(latitude: selectedPosition.latitude, longitude: selectedPosition.longitude));

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: selectedPosition.latitude,
        longitude: selectedPosition.longitude);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Localização atual'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Selecione no Mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(4),
          child: TextButton.icon(
            icon: Icon(Icons.text_fields),
            onPressed: () async {
              final enteredAddress = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddressInputScreen(widget.onSelectMap),
                ),
              );
              if (enteredAddress != null && enteredAddress.isNotEmpty) {
                try {
                  final coordinates = await _geocodingService.getCoordinatesFromAddress(enteredAddress);
                  if(coordinates != null) {
                    widget.onSelectMap(PlaceLocation(latitude: coordinates['latitude']!, longitude: coordinates['longitude']!));

                    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
                        latitude: coordinates['latitude']!,
                        longitude: coordinates['longitude']!);
                    setState(() {
                      _previewImageUrl = staticMapImageUrl;
                    });
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Endereço não encontrado!"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            label: Text('Digitar endereço'),
          ),
        )
      ],
    );
  }
}
