import 'package:fluter_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:fluter_app/database/database.dart' show conn;
import 'dart:math';


void main()async{
	await HTML.getBooks();
	runApp(const App());
}

class App extends StatelessWidget{
	@override
	Widget build(BuildContext context){
		return MaterialApp(
			routes: {
				'/':(context) => HTML(),
				'/add':(context) => HTML(type:1)
			},
		);
	}
	const App({super.key});
}

class HTML extends StatefulWidget{
	static List<String> genres=[];
	final int type;
	final Book? oldBook;
	static List<Book> books=[];

	static Future<void> update(Map book)async{
		conn.updateBook(Book(book['name'], book['author'], book['genres'], book['synopsis'], book['url'],''));
	}

	static Future<void> getBooks()async{
		try{
			books=await conn.getAllBooks();
			genres=await conn.getGenres();
		}catch(e){
			print(e);
		}
	}

	@override
	State<HTML> createState() => _HTMLState();
	HTML({super.key,this.type=0,this.oldBook});
}


class _HTMLState extends State<HTML> {

	List<DropdownMenuItem> _getGenres(){
			List<DropdownMenuItem> items=[
				const DropdownMenuItem(
						value:'',
						child:Text('')
					)
				];
			for(String genre in HTML.genres){
				items.add(DropdownMenuItem(
						value:genre,
						child:Text(genre)
					)
				);
			}
			return items;
	}

	void seeRemoveAndUpdate(){
		for(Book book in HTML.books){
			book.remove??=(){
				conn.removeBook(book.id).then((bool value){
						if(value){
							HTML.getBooks().then((value){
								setState((){});
							});
						}
					});
			};
			book.update??=(){
				HTML.getBooks().then((value){
					setState((){});
				});
			};
		}
	}

	String filter='';

	@override
	Widget build(BuildContext context){
		if(widget.type==0){//section of books
			seeRemoveAndUpdate();
			BookList books=BookList(HTML.books);
			return Scaffold(
				appBar: AppBar(
					title: const Text('section of books!!!'),
				),
				body: Column(
					children: [
						DropdownButton(
							items: _getGenres(),
							value: filter,
							onChanged: (target){
								setState(() {
									filter=target;
								});
						}),
						Expanded(child: books.getBooks(filter)),
					],
				),
				floatingActionButton: FloatingActionButton(
					mini: true,
					backgroundColor: Colors.black,
					child:const Icon(Icons.arrow_right_rounded,color:Colors.white,),
					onPressed: (){
						Navigator.of(context).pushNamed('/add').then((val){
							HTML.getBooks().then((value){
								setState((){});
							});
						});
					},
				),
			);
		}else if(widget.type==1){//add new book
			return AddNewBook();
		}else{
			return AddNewBook(oldBook: widget.oldBook);
		}
	}
}


class BookList{
	List<Book> books;

	Widget getBooks(filter){
		List<Book> bookList=[];
		for(int index=0;index<books.length;index++){
			if(filter==''){
				bookList.add(books[index]);
			}
			else{
				for(String genre in books[index].genres){
					if(genre==filter){
						bookList.add(books[index]);
						break;
					}
				}
			}
		}
		return ListView.builder(
			shrinkWrap: true,
			itemCount: bookList.length,
			itemBuilder: (context, index) => DisplayBook(bookList[index])
		);
	}
	BookList(this.books);
}


class DisplayBook extends StatelessWidget{
	static List<Color> colors=[
		const Color.fromARGB(255, 240, 255, 240),
		const Color.fromARGB(240, 230, 255, 230),
		const Color.fromARGB(255, 235, 245, 255),
		const Color.fromARGB(240, 230, 230, 255),
		const Color.fromARGB(255, 255, 235, 245),
		const Color.fromARGB(240, 255, 230, 230),
	];

	final Book book;
	BoxConstraints constant(double x)=>BoxConstraints(minWidth:5,maxWidth:(x<450)?x*0.55:x*0.65);


	@override
	Widget build(BuildContext context){
		double x = MediaQuery.of(context).size.width;
		return Container(
			constraints:const BoxConstraints(minHeight: 125),
			margin:const EdgeInsets.only(top: 7.5),
			padding:const EdgeInsets.only(top:8,bottom:8),
			decoration:BoxDecoration(
				border:Border.all(color: Colors.black),
				color:DisplayBook.colors[Random().nextInt(colors.length)]
			),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						margin: const EdgeInsets.only(left: 20,right: 20),
						child: Container(
							width: x/5,
							height:x/5,
							child: Image.network(book.url,height: 155,),
						)
					),
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Container(//title
								constraints:constant(x),
								child: Text(
									book.title,
									style: const TextStyle(
										fontSize: 20,
										fontWeight: FontWeight.bold
									)),
							),
							Container(//author
								constraints:constant(x),
								child:Text(book.author)
							),
							Container(//description
								constraints:constant(x),
								child: Text("description: ${book.description}")
							),
							Row(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									IconButton(//delete
										icon: const Icon(Icons.delete_forever_outlined,color: Colors.red,weight: 45),
										onPressed: (){
											if(book.remove!=null){
												book.remove!();
											}
										}
									),
									IconButton(//edit
										icon: const Icon(Icons.edit_document,color: Colors.green,),
										onPressed: (){
											Navigator.push(
												context,
												MaterialPageRoute(
													builder: (context)=>HTML(
														type:2,
														oldBook: book,
														)
													)
												).then((value){
													book.update!();
												});
										}
									),
								],
							)
						],
					)
				],
			)
		);
	}
	const DisplayBook(this.book,{super.key});
}


class AddNewBook extends StatefulWidget{
	final Book? oldBook;
	@override
	State<AddNewBook> createState() => _AddNewBookState();

	AddNewBook({super.key,this.oldBook});
}

class _AddNewBookState extends State<AddNewBook> {
	final TextEditingController title=TextEditingController();

	final TextEditingController authorName=TextEditingController();

	final TextEditingController description=TextEditingController();

	final TextEditingController genres=TextEditingController();

	final TextEditingController imgUrl=TextEditingController();

	String errorContent='';

	@override
	Widget build(BuildContext context){
		if(widget.oldBook!=null){
			title.text=widget.oldBook!.title;
			authorName.text=widget.oldBook!.author;
			description.text=widget.oldBook!.description;
			String tempText=widget.oldBook!.genres.toString();
			tempText=tempText.replaceAll(RegExp(r'[!@#\$%¨&*()\{\}\[\]]'),'').replaceAll(', ', '');
			genres.text=tempText;
			imgUrl.text=widget.oldBook!.url;
		}
		return Scaffold(
			appBar: AppBar(
				title:const Text('adicione um livro!!!'),
			),
			body:Column(
				children:[
					TextFormField(
						decoration: const InputDecoration(
							labelText: 'digite o nome do livro!',
						),
						controller: title,
					),
					TextFormField(
						decoration: const InputDecoration(
							labelText: 'digite o nome do autor do livro!',
						),
						controller: authorName,
					),
					TextFormField(
						decoration: const InputDecoration(
							labelText: 'digite a descrição do livro!',
						),
						controller: description,
					),
					TextFormField(
						decoration: const InputDecoration(
							labelText: 'digite os gêneros do livro(separando-os por ,)!',
						),
						controller: genres,
					),
					TextFormField(
						decoration: const InputDecoration(
							labelText: 'digite a url da capa do livro!',
						),
						controller: imgUrl,
					),
					Text(errorContent,
					style: const TextStyle(
						color: Colors.red,
					)),
					TextButton(onPressed: (){
						if(widget.oldBook==null){
							if(title.text!=''&&authorName.text!=''&&genres.text!=''&&description.text!=''&&imgUrl.text!=''){
								conn.save(Book(title.text, authorName.text, genres.text.split(', '), description.text, imgUrl.text, '')).then((Map<String,dynamic> error){
									if(!error['error']){
										Navigator.pop(context);
									}else{
										setState(() {
											errorContent=error['msg'];
										});
									}
								});
							}
						}else{
							if(title.text!=''&&authorName.text!=''&&genres.text!=''&&description.text!=''&&imgUrl.text!=''){
								conn.updateBook(
									Book(title.text, authorName.text, genres.text.split(', '), description.text, imgUrl.text, widget.oldBook!.id)
								).then((Map<String,dynamic> error){
									if(!error['error']){
										Navigator.pop(context);
									}else{
										setState(() {
											errorContent=error['msg'];
										});
									}
								});
							}
						}
					}, child: const Text('salvar'))
				],
			)
		);
	}
}
