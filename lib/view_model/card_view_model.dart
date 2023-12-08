import 'package:flutter/material.dart';
import 'package:mini_tourist/model/card_status.dart';
import 'package:mini_tourist/model/client.dart';

class CardViewModel extends ChangeNotifier {
  final CardApiService _apiService = CardApiService();

  Future<void> addCardStatus({
    required int clientId,
    required String status,
    required String city,
    required DateTime date,
  }) async {
    try {
      final cardStatus = CardStatus(
        clientId: clientId,
        status: status,
        city: city,
        date: date,
      );

      await _apiService.registerStatus(cardStatus);
      print('Status created');
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  Future<void> donwloadImage(String imageURL) async {
    try {
      await _apiService.downloadImage(imageURL);

      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }
}