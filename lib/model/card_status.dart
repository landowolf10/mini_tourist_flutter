import 'dart:convert';
import 'package:http/http.dart' as http;

class CardStatus {
  int clientId;
  String status;
  String city;
  DateTime date;

  CardStatus({
     required this.clientId,
     required this.status,
     required this.city,
     required this.date
  });

  factory CardStatus.fromJson(Map<String, dynamic> json) {
    return CardStatus(
      clientId: json['clientId'],
      status: json['status'],
      city: json['city'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'status': status,
      'city': city,
      'date': date.toIso8601String(),
    };
  }
}

class CardApiService {
  static const String baseUrl = 'http://192.168.0.2:9090/api/card/cards';

  Future<void> registerStatus(CardStatus cardStatus) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cardStatus.toJson()),
    );

    if (response.statusCode == 200) {
      print("Status created");
    } else {
      throw Exception('Failed to add status');
    }
  }
}