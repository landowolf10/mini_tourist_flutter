import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:mini_tourist/model/client.dart';
import 'package:mini_tourist/view_model/card_view_model.dart';
import 'package:mini_tourist/view_model/client_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ClientApiService apiService = ClientApiService();
  late ClientViewModel clientViewModel;
  final CardViewModel cardViewModel = CardViewModel();
  late List<String> images = [];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    clientViewModel = ClientViewModel(); // Initialize ViewModel
    clientViewModel.addListener(_onCardNamesUpdated); // Listen for changes
    getCardNames(); // Fetch card names
  }

  @override
  void dispose() {
    clientViewModel.removeListener(_onCardNamesUpdated); // Remove listener
    clientViewModel.dispose(); // Dispose ViewModel
    super.dispose();
  }

  void _onCardNamesUpdated() {
    // Handle updates when card names change
    setState(() {}); // Trigger a rebuild to update the UI with new card names
    String baseImageURL = 'http://192.168.0.2:9090/api/card/premium/';
    images = clientViewModel.cardNames.map((cardInfo) => '$baseImageURL${cardInfo.cardName}.jpg').toList();

    print('Card names loaded: $images');
  }

  Future<void> getCardNames() async {
    try {
      await clientViewModel.fetchCardNamesByCategory('premium');
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  void displayImageDetails(int index) {
    final selectedClientId = clientViewModel.cardNames[index].clientId; // Get the database ID

    if (selectedClientId != null) {
      print("Selected client id: $selectedClientId");

      cardViewModel.addCardStatus(
        clientId: selectedClientId,
        status: 'Visited',
        city: 'Zihuatanejo',
        date: DateTime.now()
      );
    }
    
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          child: Column( 
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(images[index]),
            SizedBox(height: 20),
            Text('Database Real ID: $selectedClientId'),
          ],
        )
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            if (images.isNotEmpty)
              SizedBox(
                height: 700,
                child: PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        displayImageDetails(index);
                      },
                      child: Image.network(images[index], fit: BoxFit.cover),
                    );
                  },
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
}
