import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/tabs/category_tab.dart';
import 'package:loja_udemy/tabs/home_tab.dart';
import 'package:loja_udemy/tabs/lojas_tab.dart';
import 'package:loja_udemy/tabs/orders_tab.dart';
import 'package:loja_udemy/widgets/cart_button.dart';
import 'package:loja_udemy/widgets/custom_drawer.dart';


class HomeScreen extends StatelessWidget {

  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: CategoryTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: LojasTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}


