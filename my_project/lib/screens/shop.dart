import 'package:flutter/material.dart';


import 'package:my_project/classes/item_data.dart';
import 'package:my_project/classes/theme_data.dart';
import 'package:my_project/models/item.dart';


class Shop extends StatefulWidget{
  const Shop({
    required this.theme,
    super.key
  });

  final MyThemeData theme;

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  List<ItemTiny> data=[
    ItemTiny(item: ItemData(id:1,name:"calça",available:0,price:45.05), onDelete:(){},updateHandler:(){}),
    ItemTiny(item: ItemData(id:1,name:"meia",available:45,price:45.05), onDelete:(){},updateHandler:(){})
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:[

        ...data
      ],
    );
  }
}
