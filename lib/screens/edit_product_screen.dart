import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class EditedProduct {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  EditedProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final _imgFocusNode = FocusNode();
  final _imgController = TextEditingController(
      text:
          'https://www.shareicon.net/data/128x128/2015/05/20/41190_empty_256x256.png');

  final _formKey = GlobalKey<FormState>();
  /* var _editedProduct =
      EditedProduct(id: '', title: '', description: '', price: 0, imageUrl: ''); */
  var _editedProduct = EditedProduct(
      id: '',
      title: 'Great Product',
      description: 'this is the product that will change your life',
      price: 1000,
      imageUrl: '');

  bool _isLoading = false;
  // to listen to changes of the img field focus
  @override
  void initState() {
    _imgFocusNode.addListener(updateImgURL);
    super.initState();
  }

  var isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      ProductProvider? selectedProduct =
          ModalRoute.of(context)!.settings.arguments as ProductProvider?;
      // setting the _editedProduct to the old product values to be shown in the form
      if (selectedProduct != null) {
        _editedProduct = EditedProduct(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          imageUrl: '',
          isFavorite: selectedProduct.isFavorite,
        );
        _imgController.text = selectedProduct.imageUrl;
      }
    }
    isInit = true;
    super.didChangeDependencies();
  }

// to avoid memory leaks
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgFocusNode.removeListener(updateImgURL);
    _imgFocusNode.dispose();
    _imgController.dispose();

    super.dispose();
  }

// to rebuild the widget when focus is lost from the img field to load the image
  void updateImgURL() {
    String? value = _imgController.text;
    if (!_imgFocusNode.hasFocus) {
      if (!value.startsWith('http') && !value.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

// this function adds a new product or update an existing one
  Future<void> _saveForm(ctx) async {
    final isValid = _formKey.currentState!.validate();
    var productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    // updating an existing product
    if (_editedProduct.id.isNotEmpty) {
      try {
        await productsProvider.updateProduct(
            _editedProduct.id,
            _editedProduct.title,
            _editedProduct.description,
            _editedProduct.price,
            _editedProduct.imageUrl,
            _editedProduct.isFavorite);
      } catch (error) {
        await buildErrorDialog(error);
      }
    } else {
      try {
        await productsProvider.addProduct(
            _editedProduct.title,
            _editedProduct.description,
            _editedProduct.price,
            _editedProduct.imageUrl);
      } catch (error) {
        await buildErrorDialog(error);
      }
    }
    setState(() => _isLoading = false);
      Navigator.pop(ctx);
  }

  Future<void> buildErrorDialog(Object error) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Okay'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(context),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // title
                    buildTitleField(context),
                    // price
                    buildPriceField(context),
                    // description
                    buildDescriptionField(),
                    //  Image URL & Preview
                    buildImageField(context)
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTitleField(BuildContext context) {
    return TextFormField(
      // enabled: true,
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_priceFocusNode),
      onSaved: (newValue) => _editedProduct.title = newValue ?? '',
      validator: titleValidator,
    );
  }

  String? titleValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please provide a title';
    }
    return null;
  }

  TextFormField buildPriceField(BuildContext context) {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
      decoration: const InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _priceFocusNode,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_descriptionFocusNode),
      onSaved: (newValue) => _editedProduct.price =
          newValue != null ? double.parse(newValue) : 0.0,
      validator: priceValidator,
    );
  }

  String? priceValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    if (double.tryParse(value) == null) {
      return 'Please provide a valid number';
    } else if (double.tryParse(value)! <= 0) {
      return 'Please enter a price greater than zero';
    }
    return null;
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      focusNode: _descriptionFocusNode,
      onSaved: (newValue) => _editedProduct.description = newValue ?? '',
      validator: descriptionValidator,
    );
  }

  String? descriptionValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Your product description can\'t be empty';
    } else if (value.length <= 10) {
      return 'Your product description can\'t be less that 10 characters';
    }
    return null;
  }

  Row buildImageField(BuildContext context) {
    //       initialValue: _editedProduct.title,

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Image Preview
        Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: (_imgController.text.isNotEmpty)
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: Image.network(_imgController.text),
                    // child: Image.asset('no_internet.jpg'),
                  )
                : const Text('Enter URL')),
        //  Image URL input
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Image URL',
            ),
            textInputAction: TextInputAction.done,
            controller: _imgController,
            focusNode: _imgFocusNode,
            onFieldSubmitted: (_) {
              _saveForm(context);
            },
            onSaved: (newValue) {
              _editedProduct.imageUrl = newValue ?? 'no_internet.jpg';
            },
            validator: imageValidator,
          ),
        ),
      ],
    );
  }

  String? imageValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a image URL';
    } else if (!value.startsWith('http') && !value.startsWith('https')) {
      return 'Please inter a valid URL ';
    }
    return null;
  }
}
