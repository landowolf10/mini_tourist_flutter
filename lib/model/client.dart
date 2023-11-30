import 'dart:convert';
import 'package:http/http.dart' as http;

class Client {
  int clientId;
  String cardName;
  String city;
  String category;
  String isPremium;
  String image;

  Client({
     required this.clientId,
     required this.cardName,
     required this.city,
     required this.category,
     required this.isPremium,
     required this.image
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json['clientId'],
      cardName: json['cardName'],
      city: json['city'],
      category: json['category'],
      isPremium: json['premium'],
      image: json['image'],
    );
  }
}

class ClientApiService {
  static const String baseUrl = 'http://192.168.0.2:9090/api/client/clients';

  Future<List<Client>> getCardsByCategory(String category) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      print("Json response: $data");

      List<Client> cardInfoList = data.map<Client>((json) {
        return Client.fromJson(json);
      }).toList();

      return cardInfoList;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load card names');
    }
  }
}