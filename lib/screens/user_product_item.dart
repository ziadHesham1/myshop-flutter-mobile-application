import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_provider.dart';

import '../widgets/product_item.dart';
import 'edit_product_screen.dart';

class UserProductItem extends StatefulWidget {
  final ProductProvider productItem;
  const UserProductItem(this.productItem, {super.key});

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.productItem.title),
          leading: CircleAvatar(
            backgroundImage: isInternetConnected
                ? NetworkImage(widget.productItem.imageUrl)
                : const AssetImage('no_internet.jpg') as ImageProvider,
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: widget.productItem);
                    });
                  },
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
