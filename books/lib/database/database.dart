
import 'dart:convert';
import 'package:fluter_app/model/book.dart';
import 'package:http/http.dart' as http;

class Communication{
	final String url;
	final int port;
	Map<String,String>header={'Content-type':'application/json'};

	final http.Client conn=http.Client();

	static Uri _getUri(host,ip,url)=>Uri.parse("$host:$ip/api/$url");

	Future<List<Book>> getAllBooks()async{
		Uri uri=_getUri(url,port,'books/');
		try{
			var response=await conn.get(
				headers:header,
				uri,
			);
      List books=jsonDecode(response.body);
			List<Book> bookList=[];
			books.forEach((el){
				bookList.add(Book(el['name'],el['author'],el['genres'],el['synopsis'],el['url'],el['id']));
			});
			return bookList;
		}catch(e){
			print('error! $e');
			return <Book>[];
		}
	}

	Future<List<String>> getGenres()async{
		Uri uri=_getUri(url,port,'books/genres/');

		try{
			var response=await conn.get(
				headers:header,
				uri,
			);
			List<String> genres=json.decode(response.body).cast<String>();
			if(genres.isEmpty){
				throw Exception('none list received');
			}else{
				return genres;
			}
		}catch(e){
			print('error $e');
      return [];
		}
	}

	Future<bool> removeBook(String id)async{
		Uri uri=_getUri(url,port,'books/');
		var response=await conn.delete(
      uri,
      headers:header,
      body: jsonEncode({'bookId':id})
    );
    Map<String,dynamic> result=(response.body.isEmpty)?{}:jsonDecode(response.body);
    if(result.containsKey('error')){
      return false;
    }else{
      return true;
    }
	}

  Future<Map<String, dynamic>> save(Book book)async{
		Uri uri=_getUri(url, port, 'books/');
		var resnponse = await conn.post(
			uri,
			body:jsonEncode(book.toMap())
		);
    Map<String,dynamic> result=jsonDecode(resnponse.body);
    if(result.containsKey('error')){
      return {
        'error': true,
        'msg':result['error']
      };
    }else{
      return {
        'error':false,
        'msg':''
      };
    }
	}

	Future<Map<String,dynamic>> updateBook(Book book)async{
		Uri uri=_getUri(url,port,'books/');
		var response=await conn.patch(
			uri,
      headers: header,
			body:jsonEncode(book.toMap())
		);
    Map result=jsonDecode(response.body);
    if(result.containsKey('error')){
      return {
        'error': true,
        'msg':result['error']
      };
    }else{
      return {
        'error':false,
        'msg':''
      };
    }
	}

	Communication(this.url,this.port);
}

Communication conn=Communication('http://10.0.25.93',8080);
