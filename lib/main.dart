import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
        ChangeNotifierProvider.value(value: Product()),
        ChangeNotifierProvider.value(value: Products()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: const TextTheme(
                  titleLarge: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  titleSmall: TextStyle(
                    fontSize: 17,
                    color: Colors.deepOrange,
                  )),
              fontFamily: 'Lato',
              splashColor: Colors.grey.shade300,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.deepOrange)),
          home: auth.isAuth
              ? const ProductOverView()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (BuildContext ctx, AsyncSnapshot snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            CartScreen.routName: (_) => const CartScreen(),
            ProductDetailsScreen.routName: (_) => const ProductDetailsScreen(),
            UserProductScreen.routName: (_) => const UserProductScreen(),
            EditProductScreen.routName: (_) => const EditProductScreen(),
            OrdersScreen.routName: (_) => const OrdersScreen(),
          },
        ),
      ),
    );
  }
}
