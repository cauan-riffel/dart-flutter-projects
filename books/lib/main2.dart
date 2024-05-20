//import 'package:fluter_app/database/database.dart';
//import 'package:flutter/material.dart';
//import 'package:fluter_app/model/tarefa.dart';

//void main() {
//	WidgetsFlutterBinding.ensureInitialized();
//	runApp(App());
//}

//class App extends StatefulWidget{
//	void start(){

//	}
//	final List<Tarefas> tarefas = [];



//	@override
//	State<App> createState() => _AppState();

//	App({super.key});
//}

//class _AppState extends State<App> {

//	Db db=Db('myDB', 'myTable');

//	void remove(int id){
//		for(int i=0;i!=widget.tarefas.length;i++){
//			if(widget.tarefas[i].childId==id){
//				db.remove(id);
//				setState(() {
//					widget.tarefas.removeAt(i);
//				});
//			}
//		}
//	}

//	void update(int id,bool type){
//		for(int i=0;i!=widget.tarefas.length;i++){
//			if(widget.tarefas[i].childId==id&&widget.tarefas[i].update!=null){
//				db.update(id, (type)?widget.tarefas[i].preferencia+1:widget.tarefas[i].preferencia-1);
//			}
//		}
//	}

//	@override
//	Widget build(BuildContext context){
//		return MaterialApp(
//			routes: {
//				'/': (context){
//					return Html(
//						0,
//						tarefas: widget.tarefas,
//						icon: FloatingActionButton(
//							child: const Icon(Icons.turn_right_sharp),
//							onPressed: (){
//								Navigator.of(context).pushNamed('/add').then((value){
//									if(value is Tarefas){
//										value.remove=remove;
//										value.update=update;
//										setState(() {
//											widget.tarefas.add(value);
//										});
//									}
//								});
//							},
//						),
//					);
//				},
//				'/add': (context){
//					return const Html(
//						1,
//					);
//				}
//			},
//		);
//	}
//}


//class Html extends StatefulWidget{
//	final int tipo;
//	final List<Tarefas>? tarefas;
//	final Widget? icon;

//	@override
//	State<Html> createState() => _HtmlState();

//	const Html(this.tipo, {this.tarefas, this.icon, super.key});
//}

//class _HtmlState extends State<Html> {

//	List<Tarefas> ordenar(List<Tarefas>?lista){
//		if(lista==null)return [];
//		List<Tarefas> obj=[];
//		Map<int, List<Tarefas>> mapita = {
//			1: [],
//			2: [],
//			3: [],
//			4: [],
//			5: [],
//			6: [],
//			7: [],
//			8: [],
//			9: [],
//			10: [],
//		};
//		for(Tarefas tarefa in lista){
//			mapita[tarefa.preferencia]!.add(tarefa);
//		}
//		int x = 10;
//		while(x>0){
//			for(Tarefas tarefa in mapita[x]!){
//				obj.add(tarefa);
//			}
//			x--;
//		}

//		return obj;
//	}

//	@override
//	Widget build(BuildContext context){
//		if(widget.tipo==0&&widget.icon!=null){
//			List<Tarefas> obj = ordenar(widget.tarefas);
//			return Scaffold(
//				appBar: AppBar(
//					title: const Text('taskMaster'),

//				),
//				body: (obj.isNotEmpty)?ListView.builder(
//					itemBuilder: (context, index){
//						return Cartao(obj[index]);
//					},
//					itemCount: obj.length,
//				):const Center(
//					child: Text('não existe nenhuma tarefa no momento')
//				),

//				floatingActionButton: widget.icon
//			);
//		}else{
//			return Scaffold(
//				appBar: AppBar(
//					title: const Text('taskMaster'),
//				),
//				body: AddTarefa(),
//			);
//		}
//	}
//}


//class AddTarefa extends StatefulWidget{
//	final List<int> values = [10,9,8,7,6,5,4,3,2,1];
//	int dropValue = 10;
//	@override
//	State<AddTarefa> createState() => _AddTarefaState();

//	AddTarefa({super.key});
//}

//class _AddTarefaState extends State<AddTarefa> {
//	final TextEditingController nome = TextEditingController();
//	final TextEditingController date = TextEditingController();
//	final TextEditingController preferencia = TextEditingController();

//	@override
//	Widget build(BuildContext context){
//		return Column(
//			children: <Widget>[
//				TextField(
//					decoration: const InputDecoration(
//							labelText: 'Nome da atividade',
//						),
//						controller: nome,
//				),
//				TextField(
//						decoration: const InputDecoration(
//							labelText: 'data final da atividade',
//						),
//						controller: date,
//				),
//				DropdownButton(
//					items: widget.values.map<DropdownMenuItem<int>>(
//						(vall){
//						return DropdownMenuItem(
//							value: vall,
//							child: Text('$vall')
//						);
//					}).toList(),
//					value: widget.dropValue,
//					onChanged: (int? val){
//						setState(() {
//							widget.dropValue = val!;
//						});
//					}),
//				TextButton(
//					onPressed: (){
//						String tarefa = nome.text,
//							data = date.text;
//						data = data.replaceAll(RegExp('[a-zA-z] /+-*/-'), '');
//						String dd, mm, aaaa;
//						if(data.length!=8){
//							data = DateTime.now().toString().substring(0, 10);
//							aaaa=data.substring(0, 4);
//							mm=data.substring(5, 7);
//							dd=data.substring(8);
//						}else{
//							dd=data.substring(0, 2);
//							mm=data.substring(2, 4);
//							aaaa=data.substring(4, 8);
//						}
//						data = '$dd/$mm/$aaaa';
//						Navigator.pop(context);
//					},
//					child: const Text('salvar'),
//				)
//			],
//		);
//	}
//}

//class Cartao extends StatelessWidget{
//	final Tarefas obj;
//	final List<Color> cores = [
//		const Color.fromARGB(255, 0, 255, 0),
//		const Color.fromARGB(255, 94, 255, 0),
//		const Color.fromARGB(255, 157, 255, 0),
//		const Color.fromARGB(255, 157, 255, 0),
//		const Color.fromARGB(255, 255, 217, 0),
//		const Color.fromARGB(255, 255, 230, 0),
//		const Color.fromARGB(255, 255, 174, 0),
//		const Color.fromARGB(255, 255, 136, 0),
//		const Color.fromARGB(255, 255, 60, 0),
//		const Color.fromARGB(255, 255, 0, 0),
//	];
//	@override
//	Widget build(BuildContext context){
//		return Card(
//			color: cores[obj.preferencia-1],
//			child: ListTile(
//				leading: IconButton(
//					onPressed: (obj.preferencia!=10&&obj.update!=Null)?(){obj.update!(true);}:null,
//					icon: const Icon(Icons.arrow_drop_up_rounded)
//				),
//				title: Text(obj.tarefa),
//				subtitle: Text(obj.data),
//				trailing: IconButton(
//					icon: const Icon(Icons.arrow_drop_down_rounded),
//					onPressed: (obj.preferencia!=10&&obj.update!=Null)?(){obj.update!(false);}:null,
//				),
//				onLongPress: (){},
//			),
//		);
//	}

//	Cartao(this.obj, {super.key});
//}
