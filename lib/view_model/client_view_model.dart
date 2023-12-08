import 'package:flutter/material.dart';
import 'package:mini_tourist/model/client.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientApiService _apiService = ClientApiService();

  List<Client> cardNames = [];

  Future<void> fetchCardNamesByCategory(String category) async {
    try {
      List<Client> names = await _apiService.getCardsByCategory(category);
      cardNames = names;

      print('Viewmodel client id: ${cardNames[0].clientId}');
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }


  /*Future<void> addPost(Post post) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      fetchPosts(); // Refresh the list after adding a post
    } else {
      throw Exception('Failed to add post');
    }
  }

  Future<void> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      fetchPosts(); // Refresh the list after updating a post
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      fetchPosts(); // Refresh the list after deleting a post
    } else {
      throw Exception('Failed to delete post');
    }
  }*/
}