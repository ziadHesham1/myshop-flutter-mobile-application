import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_model.dart';

class CartItem extends StatefulWidget {
  final ProductModel desiredProduct;

  const CartItem(this.desiredProduct, {super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var productCounter = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                '${widget.desiredProduct.price}',
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
        title: Text(widget.desiredProduct.title),
        subtitle:
            Text('Total : ${widget.desiredProduct.price * productCounter}'),
        trailing: TextButton(
          onPressed: () {
            setState(() {
              productCounter++;
            });
          },
          child: Text('$productCounter x'),
        ),
      ),
    );
  }
}
