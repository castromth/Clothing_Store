import 'package:flutter/material.dart';
import 'package:loja_udemy/models/cart_model.dart';
import 'package:loja_udemy/models/user_model.dart';
import 'package:loja_udemy/ui/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoped_model/scoped_model.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context,child,model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'Flutter Clothing',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141)
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        }
      )
    );
  }
}

