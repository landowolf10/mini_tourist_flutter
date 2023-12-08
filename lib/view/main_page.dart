import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:mini_tourist/model/client.dart';
import 'package:mini_tourist/view_model/card_view_model.dart';
import 'package:mini_tourist/view_model/client_view_model.dart';
import 'package:widget_slider/widget_slider.dart';

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
  String dropdownValue = 'Categoría';
  var categories = [  
    'Categoría',   
    'Premium', 
    'Parques y atracciones', 
    'Restaurantes, bares y cafeterías', 
    'Lugares y eventos', 
    'Tiendas',
    'Servicios' 
  ];
  final controller = SliderController(
    duration: const Duration(milliseconds: 600),
  );
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
    setState(() {}); // Trigger a rebuild to update the UI with new card names
    String baseImageURL = 'http://192.168.0.2:9090/api/card/premium/';
    images = clientViewModel.cardNames.map((cardInfo) => '$baseImageURL${cardInfo.cardName}.jpg').toList();
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
  final selectedClientId = clientViewModel.cardNames[index].clientId;
  final imageURL = images[index];

  cardViewModel.addCardStatus(
    clientId: selectedClientId,
    status: 'Visited',
    city: 'Zihuatanejo',
    date: DateTime.now(),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),
              Image.network(images[index])
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              cardViewModel.donwloadImage(imageURL);
              cardViewModel.addCardStatus(
                clientId: selectedClientId,
                status: 'Downloaded',
                city: 'Zihuatanejo',
                date: DateTime.now(),
              );
              print("Downloaded image: $imageURL");
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Descargar cupón')
              ],
            ),
          )
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
          SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align children at the start
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
            child: WidgetSlider(
              fixedSize: 300,
              controller: controller,
              itemCount: images.length,
              itemBuilder: (context, index, activeIndex) {
                return TextButton(
                  onPressed: () async {
                    await controller.moveTo?.call(index);
                    displayImageDetails(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(images[index]),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade50,
                          offset: const Offset(0, 8),
                          spreadRadius: 5,
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade100,
                          offset: const Offset(0, 8),
                          spreadRadius: 5,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: DropdownButton(
              value: dropdownValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: categories.map((String categories) {
                return DropdownMenuItem(
                  value: categories,
                  child: Text(categories),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!.toLowerCase().replaceAll(' ', '_');
                  print("Selected category: " + dropdownValue);
                });
              },
            ),
          ),
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
