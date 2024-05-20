import 'package:flutter/material.dart';
import 'package:my_project/classes/theme_data.dart';
import 'package:my_project/screens/shop.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget{

  const MyApp({super.key});

  @override
  State<MyApp> createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp>{

  void changeIndex(int index){
    setState((){
      selected=index;
    });
  }


  final MyThemeData theme=MyThemeData(
    darkMode: true
  );
  final List<Color> cols=[
    const Color.fromARGB(255, 105, 105, 105),
    Color.fromARGB(255, 190, 6, 0)
  ];



  int selected=0;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        backgroundColor:theme.getBeckGroundColor(true),
        body:AnimatedContainer(
          duration:const Duration(milliseconds:750),
          child:selected==0?
            null
          :
            Shop(theme:theme),
        ),
        bottomNavigationBar:BottomNavigationBar(
          backgroundColor:theme.getBeckGroundColor(false),
          items:const<BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Icon(Icons.people_alt_outlined),
              label:"Pessoas"
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.monetization_on),
              label:"Itens",
            ),
          ],
          currentIndex:selected,
          onTap:changeIndex,
          unselectedItemColor:Colors.grey,
          selectedItemColor:cols[selected],
          iconSize:28,
        ),
        floatingActionButton:IconButton(
          iconSize:12,
          hoverColor:theme.getTextColor(),
          focusColor: theme.getBeckGroundColor(false),
          icon:theme.darkMode?
            const Icon(Icons.light_mode_outlined)
          :
            const Icon(Icons.dark_mode_outlined,),
          onPressed: (){
            setState(() {
              theme.darkMode=!theme.darkMode;
            });
          },
        ),
      ),
      debugShowCheckedModeBanner:false,
    );
  }
}
