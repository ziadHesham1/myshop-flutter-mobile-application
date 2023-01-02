import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order_provider.dart';

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {Key? key}) : super(key: key);

  final OrderItemModel order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = true;

  @override
  Widget build(BuildContext context) {
    var dateTime = DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime);
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toString()}'),
            subtitle: Text(dateTime.toString()),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() => _expanded = !_expanded);
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.cartProducts.length * 20 + 10, 100),
              child: ListView.builder(
                itemCount: widget.order.cartProducts.length,
                itemBuilder: (context, index) {
                  var cartItem = widget.order.cartProducts[index];
                  return ListTile(
                    title: Text(
                      cartItem.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: Text(
                      '${cartItem.quantity}x\$${cartItem.price}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
