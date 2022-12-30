import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String cartItemId;
  final CartItemModel cartItemValues;

  const CartItem(this.cartItemId, this.cartItemValues, {super.key});
  @override
  Widget build(BuildContext context) {
    var cartItemPrice = cartItemValues.price;
    var cartItemQuantity = cartItemValues.quantity;
    var itemMargin = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 4,
    );
    // Dismissible is a widget that allow to swipe its child and take an action when swiped
    return Dismissible(
      key: ValueKey(cartItemId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
      // direction argument is used to give a different action for each swipe direction
        Provider.of<CartProvider>(context,listen: false).removeCartItem(cartItemId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        /*  to make sure that the background is only behind the card
         set the same margin assigned to the card */
        margin: itemMargin,
        // delete icon
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: itemMargin,
        elevation: 4,
        // the item of the listView.builder (ListTile)
        child: ListTile(
          // the circle in the left of the card that contains the price
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              // FittedBox change fontSize to make the text visible in the available space
              child: FittedBox(
                child: Text(
                  '$cartItemPrice',
                  style: const TextStyle(color: Colors.white),
                  // to make sure the text is not cropped out because of the space 
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          title: Text(cartItemValues.title),
          subtitle: Text('Total : ${cartItemPrice * cartItemQuantity}'),
          trailing: Text('$cartItemQuantity x'),
        ),
      ),
    );
  }
}
