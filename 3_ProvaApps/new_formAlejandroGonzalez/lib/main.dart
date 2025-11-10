import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recuperar el valor d''un camp de text',
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});
  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(//Titulo
        title: const Text('Alejandro González S2AM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(//pop up simple
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('SimpleDialog'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Bordes cuadrados
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(myController.text),
                      ), //texto centrado
                    ],
                  );
                },
              );
            },
            tooltip: 'Botón 1',
            child: const Icon(Icons.looks_one),
          ),
          FloatingActionButton(// snack bar: es como un pop up pero con temporizador
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(myController.text),
                  duration: Duration(seconds: 2),
                )
              );
            },
            tooltip: 'Botón 2',
            child: const Icon(Icons.looks_two),
          ),
          FloatingActionButton(//como el primero pero con un boton
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('AlertDialog'),
                    content: Text(myController.text),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Bordes cuadrados
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AlertDialog cerrado')),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Botón 3',
            child: const Icon(Icons.looks_3),
          ),         
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(myController.text),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Tancar BottomSheet'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: 'Mostra el valor!',
            child: const Icon(Icons.text_fields),
          ),
        ],
      ),
    );
  }
}