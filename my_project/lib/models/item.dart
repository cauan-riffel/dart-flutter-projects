import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/classes/item_data.dart';


class ItemFull extends StatefulWidget{
  final ItemData item;
  final Function updateHandler;


  const ItemFull({
    required this.item,
    required this.updateHandler,
    super.key
  });

  @override
  State<ItemFull> createState() => _ItemFullState();
}

class _ItemFullState extends State<ItemFull> {
  TextEditingController      nameController=TextEditingController();
  TextEditingController availableController=TextEditingController();
  TextEditingController     priceController=TextEditingController();
  TextEditingController b=TextEditingController();
  TextEditingController c=TextEditingController();






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.005),
        shadowColor: Color.fromRGBO(0, 0, 0, 0.005),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back,color:Colors.black,),
              onPressed: () { Navigator.pop(context);},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20,right:20),
            child: SizedBox(
              height: 65,
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    controller: nameController..text=widget.item.name,
                    decoration:const InputDecoration(
                      counterStyle: TextStyle(fontSize: 10),
                      labelText:"Nome",
                    ),
                    onChanged:(String newStr){
                      widget.item.name=nameController.text;
                    },
                  ),
                ),
              ),
          ),

          Padding(
            padding: const EdgeInsets.only(left:20,right:20),
            child: SizedBox(
              height: 65,
              child: SizedBox(
                height: 65,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: availableController..text="${widget.item.available}",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'))
                  ],
                  decoration:const InputDecoration(
                    counterStyle: TextStyle(fontSize: 10),
                    labelText:"Disponíveis:"
                  ),
                  onChanged:(String newStr){
                    if(int.tryParse(newStr)!=null){
                      widget.item.available=int.parse(newStr);
                    }
                  },
                  maxLength: 16,
                ),
              ),
            ),
          ),


           Padding(
            padding: const EdgeInsets.only(left:20,right:20),
            child: SizedBox(
              height: 65,
              child: SizedBox(
                height: 65,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: priceController..text="${widget.item.price}",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]+$'))
                  ],
                  decoration:const InputDecoration(
                    counterStyle: TextStyle(fontSize: 10),
                    labelText:"Preço:",
                    prefixIcon: Icon(Icons.monetization_on_outlined,color:Colors.green,)
                  ),
                  onChanged:(String newStr){
                    if(double.tryParse(newStr)!=null){
                      widget.item.price=double.parse(newStr);
                    }
                  },
                  maxLength: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






class ItemTiny extends StatelessWidget{
  final ItemData item;
  final Function onDelete,updateHandler;
  const ItemTiny({
    required this.item,
    required this.onDelete,
    required this.updateHandler,
    super.key
  });


  ItemData getData(){
    return item;
  }


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:12),
      child: ListTile(
        title: Text(item.name),
        subtitle:item.description!=null?
          Text(item.description!)
        :
          null,
          leading: item.available==0?
            const Icon(Icons.shopping_basket_outlined,color: Colors.red,)
          :
            const Icon(Icons.shopping_basket,color: Colors.green,),
          onLongPress:()=>onDelete(),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder:(context)=>ItemFull(item: item,updateHandler: updateHandler))
            );
          },
      ),
    );
  }
}
