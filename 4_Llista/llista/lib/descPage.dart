import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:llista/api_elements.dart';

class DescPage extends StatefulWidget {
  final ElementosAPI item;
  
  const DescPage({
    super.key,
    required this.item,
  });

  @override
  State<DescPage> createState() => _DescPageState();
}

class _DescPageState extends State<DescPage> {
  late ElementosAPI _currentItem;
  late TextEditingController _ratingController;
  late double _ratingValue;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _ratingValue = _currentItem.rating;
    _ratingController = TextEditingController(
      text: _ratingValue.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _ratingController.dispose();
    super.dispose();
  }

  // Actualiza el rank, ns porque no se actualiza
  Future<void> _updateRating() async {
    final newRating = _ratingValue;
    
    if (newRating >= 0 && newRating <= 10) {
      setState(() {
        _currentItem = ElementosAPI(
          id: _currentItem.id,
          name: _currentItem.name,
          mythology: _currentItem.mythology,
          description: _currentItem.description,
          shortDescription: _currentItem.shortDescription,
          image: _currentItem.image,
          imageLogo: _currentItem.imageLogo,
          rating: newRating,
        );
        _ratingController.text = newRating.toStringAsFixed(1);
      });

      // Convert to JSON
      final updatedJson = _currentItem.toJson();
      
      // Save to JSON file
      await _saveUpdatedJson(updatedJson);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating updated to ${newRating.toStringAsFixed(1)}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid rating between 0 and 10'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Guarda el json actualizado-
  Future<void> _saveUpdatedJson(Map<String, dynamic> json) async {
      // lee el json actual
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/sample.json');
      
      // lo pasa a lista
      List<dynamic> jsonList = jsonDecode(jsonString);
      
      // busca el item seleccionado con los del json
      int index = jsonList.indexWhere((item) => item['id'] == json['id']);
      if (index != -1) {
        jsonList[index] = json;
        
        final file = File('assets/sample.json');
        
        // actualiza el json
        await file.writeAsString(jsonEncode(jsonList));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//widget base, es basicamente la pantalla
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _currentItem.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(//declara el icono de la imaagen del logo, y lo que pasa cuando se hará click
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            //container de la imagen, se verá como portrait (ampliada)
            Container(
              width: 300,
              height: 400,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(//bordes redondos
                borderRadius: BorderRadius.circular(15),
                child: Image.asset( //caarga la imagen de assets
                  _currentItem.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Información de la bestia
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _currentItem.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Mythology
                  Text(
                    "Mythology: ${_currentItem.mythology}",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // El rango
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Rating: ${_currentItem.rating.toStringAsFixed(1)}/10.0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Slider del rank 
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Rating:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Slider(
                          value: _ratingValue,
                          min: 0,
                          max: 10,
                          divisions: 100,
                          label: _ratingValue.toStringAsFixed(1),
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              _ratingValue = value;
                              _ratingController.text = value.toStringAsFixed(1);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey[700]!),
                        ),
                        child: Text(
                          _ratingValue.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // btn submit
                  const SizedBox(height: 8), 
                  Center(
                    child: ElevatedButton(
                      onPressed: _updateRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    "Description:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    _currentItem.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}