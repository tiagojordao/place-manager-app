import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  final String apiKey = 'API_KEY';

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final lat = data['results'][0]['geometry']['location']['lat'];
          final lng = data['results'][0]['geometry']['location']['lng'];

          return {'latitude': lat, 'longitude': lng};
        } else {
          throw 'Erro: Endereço não encontrado';
        }
      } else {
        throw 'Erro: Não foi possível conectar à API de geocodificação';
      }
    } catch (error) {
      throw 'Erro: $error';
    }
  }
}
