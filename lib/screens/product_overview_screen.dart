
import 'package:flutter/material.dart';

class ProductOverView extends StatefulWidget {
  const ProductOverView({Key? key}) : super(key: key);

  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('main screen') ,
      ),
    );
  }
}
