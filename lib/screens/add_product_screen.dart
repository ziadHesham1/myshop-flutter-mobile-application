import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  static const routeName = '/EditProductScreen';
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Image URL',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
