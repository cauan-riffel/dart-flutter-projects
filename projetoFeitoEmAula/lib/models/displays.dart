import 'package:aulinha/models/characters.dart';
import 'package:flutter/material.dart';
import 'package:aulinha/utils/getters.dart';

void changeState(Future f,Function update,List<Widget>btn)async{
	f.then((result){
    if(result[0]==null){//topics
      Iterable<String> keys=result.keys;
      update(ListView.builder(
        itemCount:result.length,
        itemBuilder:(ctx,i){
          return ListTile(
            title:Text(keys.elementAt(i)),
            onTap:(){Navigator.pushNamed(ctx, result[keys.elementAt(i)]);},
          );
        }
      ));
    }else if(result[1] is Character){
      int l=result.length-1+btn.length;
      update(ListView.builder(
      itemCount:l,
      scrollDirection: Axis.vertical,
      itemBuilder:(ctx,i){
        if(result.length-1>i){
          Character item=result[i+1];
          return CharacterTiny(item);
        }else{
          return btn[(i-result.length+1)as int];
        }

      },
    ));
    }else if(result[1] is Location){
      int l=result.length-1+btn.length;
      update(ListView.builder(
      itemCount:l,
      scrollDirection: Axis.vertical,
      itemBuilder:(ctx,i){
        if(result.length-1>i){
          Location item=result[i+1];
          return LocationTiny(item);
        }else{
          return btn[(i-result.length+1)as int];
        }
    }));
    }else{
      int l=result.length-1+btn.length;
      update(ListView.builder(
      itemCount:l,
      scrollDirection: Axis.vertical,
      itemBuilder:(ctx,i){
        if(result.length-1>i){
          Episode item=result[i+1];
          return EpisodeTiny(item);
        }else{
          return btn[(i-result.length+1)as int];
        }
    }));
    }
	});
}

class ShowItem extends StatefulWidget{
	var item;
  bool update=true;
  List<Widget> data=[];
  List contents=[];

  @override
  State<ShowItem> createState() => _ShowItemState();

	ShowItem(this.item,{super.key}){
		if(item is List<Episode>){
      item=item[0];
    }if(item is!Character&&item is!Location&&item is!Episode){
			throw Exception('valor incorreto, $item');
		}
	}
}

class _ShowItemState extends State<ShowItem> {
	@override
	Widget build(context){
    var item=widget.item;
		if(item is Character&&widget.update==true){
      widget.data=[
        Image.network(item.image,
          height: 125,
        ),
        Text.rich(TextSpan(
          text:'Status: ',
          children:[
            TextSpan(text:item.status,style:TextStyle(color:(item.status=='Alive')?Colors.green[200]:(item.status=='unknown')?Colors.black45:Colors.red[200]))
          ]
        )),
        Text('Specie: ${item.species}'),
        Text('Genero: ${item.gender}'),
        Text('Especie: ${item.species}'),
        InkWell(
          onTap:(item.origin['url']=="")?null:()=>getLocations(
            id:int.parse(
            item.origin['url'].toString().replaceAll('$baseUrl/location/','')
          )).then((value){
            Navigator.push(context,
              MaterialPageRoute(builder:(ctx)=>ShowItem(value[0]))
            );
          }),
          child:Text('Origem: ${item.origin['name']}')
          ),
        InkWell(
          onTap:(item.location['url']=="")?null:()=>getLocations(
          id:int.parse(
            item.origin['url'].toString().replaceAll('$baseUrl/location/','')
          )).then((value)=>Navigator.push(context,
            MaterialPageRoute(builder:(ctx)=>ShowItem(value[0]))
        )),
        child:Text('Ultima vez visto:${item.location['name']}')),
        Text("Criado: ${item.created}"),
        const Text('Episódios:')
        ];
			getEpisodes(
        ids:item.episode.map((e)=>int.parse(e.replaceAll('$baseUrl/episode/',''))).toList()
      ).then((value){
        setState(() {
          widget.contents=value;
          widget.update=false;
        });

      });
		}else if(item is Location&&widget.update==true){
      widget.data=[Text('Tipo: ${item.type}'),Text('Dimenção: ${item.dimension}'),Text('Criado: ${item.created}'),const Text('Personagens: ')];

      getCharacters(
        ids:item.residents.map((e)=>int.parse(e.replaceAll('$baseUrl/character/',''))).toList()
      ).then((value){
        setState((){
          widget.contents=value;
          widget.update=false;
        });
      });

		}else if(item is Episode&&widget.update==true){
      widget.data=[Text('Episodio:${item.ep}'),Text('Temporada: ${item.season}'),Text('Lançado: ${item.created}'),const Text('Personagens:')];

      getCharacters(
        ids:item.characters.map((e)=>int.parse(e.replaceAll('$baseUrl/character/',''))).toList()
      ).then((value){
        setState((){
          widget.contents=value;
          widget.update=false;
        });
      });
		}else if(widget.data.isEmpty) return const Text('error on load data!');
    List<Widget> items=widget.data;
    items.addAll(widget.contents.map((e)=>e is Episode?EpisodeTiny(e):e is Character? CharacterTiny(e):LocationTiny(e)).toList());
    print(items);
		return Scaffold(
			appBar:AppBar(title:Text(item.name)),
			body:
				ListView(
					children:widget.data,
				)
		);
	}
}

class CharacterTiny extends StatelessWidget{
  final Character c;

  Widget build(ctx){
    return ListTile(
      contentPadding:const EdgeInsets.only(left:20,top:2,bottom:2),
      title:Text(c.name),
      onTap:()=>Navigator.push(ctx,MaterialPageRoute(builder:(ctx)=>ShowItem(c))),
      leading:ClipRRect(
        borderRadius:BorderRadius.circular(10),
        child:Image(image:NetworkImage(c.image)),
      )
    );
  }

  const CharacterTiny(this.c,{super.key});
}

class LocationTiny extends StatelessWidget{
  final Location e;

  Widget build(ctx){
    return ListTile(
      contentPadding:const EdgeInsets.only(left:20,top:2,bottom:2),
      title:Text(e.name),
      subtitle:Text('Criado: ${e.created}'),
      onTap:()=>Navigator.push(ctx,MaterialPageRoute(builder:(ctx)=>ShowItem(e))),
      leading:Icon(Icons.read_more,color:Colors.amber[200],)
    );
  }

  const LocationTiny(this.e,{super.key});
}

class EpisodeTiny extends StatelessWidget{
  final Episode e;

  Widget build(ctx){
    return ListTile(
      contentPadding:const EdgeInsets.only(left:20,top:2,bottom:2),
      title:Text(e.name),
      subtitle:Text('Criado: ${e.created}'),
      onTap:()=>Navigator.push(ctx,MaterialPageRoute(builder:(ctx)=>ShowItem(e))),
      leading:Icon(Icons.read_more,color:Colors.amber[200],)
    );
  }

  const EpisodeTiny(this.e,{super.key});
}

class DisplayTopics extends StatefulWidget{
	Widget data=const Text('coletando tópicos...');

	@override
	State<DisplayTopics> createState() => _DisplayTopicsState();

	DisplayTopics({super.key});
}

class _DisplayTopicsState extends State<DisplayTopics> {

	void update(Widget anotherData){
		setState((){
			widget.data=anotherData;
		});
	}

	@override
	Widget build(ctx){
		return widget.data;
	}
	_DisplayTopicsState(){
		changeState(getTopics(),update,[]);
	}
}

class DisplayCharacters extends StatefulWidget{
	Widget data=const Text('collecting data...');
  int page=1;
  bool get=true;
	@override
	State<DisplayCharacters> createState()=>_DisplayCharactersState();
  DisplayCharacters({super.key});
}

class _DisplayCharactersState extends State<DisplayCharacters> {
	void getData(){
    List<Widget> arr=[
      IconButton(onPressed:widget.page!=1?(){setState((){widget.page--;widget.get=true;});}:null, icon:const Icon(Icons.arrow_back)),
      IconButton(onPressed:widget.page!=42?(){setState((){widget.page++;widget.get=true;});}:null, icon:const Icon(Icons.arrow_forward))
    ];
		changeState(getCharacters(page:widget.page),update,arr);
	}

	void update(Widget anotherData){
		setState((){
      widget.get=false;
			widget.data=anotherData;
		});
	}

	@override
	Widget build(ctx){
    if(widget.get)getData();
		return widget.data;
	}

	_DisplayCharactersState();
}

class DisplayLocations extends StatefulWidget{
	Widget data=const Text('collecting data...');
  int page=1;
  bool get=true;
	@override
	State<DisplayLocations> createState()=>_DisplayLocationsState();
  DisplayLocations({super.key});
}

class _DisplayLocationsState extends State<DisplayLocations> {

	void getData(){
    print(widget.page);
    List<Widget> arr=[
      IconButton(onPressed:widget.page!=1?(){setState((){widget.page--;widget.get=true;});}:null, icon:const Icon(Icons.arrow_back)),
      IconButton(onPressed:widget.page!=7?(){setState((){widget.page++;widget.get=true;});}:null, icon:const Icon(Icons.arrow_forward))
    ];
		changeState(getLocations(page:widget.page),update,arr);
	}

	void update(Widget anotherData){
		setState((){
      widget.get=false;
			widget.data=anotherData;
		});
	}

	@override
	Widget build(ctx){
    if(widget.get)getData();
		return widget.data;
	}

  _DisplayLocationsState();
}

class DisplayEpisodes extends StatefulWidget{
	Widget data=const Text('collecting data...');
  int page=1;
  bool get=true;
	@override
	State<DisplayEpisodes> createState()=>_DisplayEpisodesState();
}

class _DisplayEpisodesState extends State<DisplayEpisodes> {

	void getData(){
    List<Widget> arr=[
      IconButton(onPressed:widget.page!=1?(){setState((){widget.page--;widget.get=true;});}:null, icon:const Icon(Icons.arrow_back)),
      IconButton(onPressed:widget.page!=3?(){setState((){widget.page++;widget.get=true;});}:null, icon:const Icon(Icons.arrow_forward))
    ];
		changeState(getEpisodes(page:widget.page),update,arr);
	}

	void update(Widget anotherData){
		setState((){
			widget.data=anotherData;
		});
	}

	@override
	Widget build(ctx){
    if(widget.get)getData();
		return widget.data;
	}

	_DisplayEpisodesState();
}
