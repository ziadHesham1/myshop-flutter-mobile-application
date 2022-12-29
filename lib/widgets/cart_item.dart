import 'package:flutter/material.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatefulWidget {
  final CartItemModel desiredProduct;
  const CartItem(this.desiredProduct, {super.key});
  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    var productCounter = widget.desiredProduct.quantity;
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              child: Text(
                '${widget.desiredProduct.price}',
                style: const TextStyle(color: Colors.white),
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
