import 'package:flutter/material.dart';



class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
static const routName='/edit';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit product screen'),
      ),
    );
  }
}
