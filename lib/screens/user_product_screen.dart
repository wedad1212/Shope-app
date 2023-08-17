import 'package:flutter/material.dart';

class UserProductScreen extends StatefulWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routName='/mainProduct';
  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('user product screen'),
      ),
    );
  }
}
