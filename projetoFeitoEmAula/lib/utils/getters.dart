import 'dart:convert';
import 'package:aulinha/models/characters.dart';
import 'package:http/http.dart' as http;

const baseUrl='https://rickandmortyapi.com/api';

Future<Map<String,dynamic>> getTopics()async{
	var res=await http.get(Uri.parse(baseUrl));
	if(res.statusCode==200){
		Map<String,dynamic> data=json.decode(res.body);
		for(String key in data.keys){
			data[key]=data[key].replaceAll(baseUrl,'');
		}
		return data;
	}
	return {'err':'t'};
}
Future<List> getCharacters({int?id,int?page,List<int>?ids})async{
	var res=await http.get(Uri.parse("$baseUrl/character/${id!=null?"$id":''}${page!=null?"?page=$page":''}${ids!=null?ids:''}"));
  if(res.statusCode==200){
    if(id!=null){
      return [Character.fromMap(jsonDecode(res.body))];
    }else if(ids!=null){
      List<Character>finalData=[];
      for(var i in jsonDecode(res.body)){
        finalData.add(Character.fromMap(i));
      }
      return finalData;
    }else{
      Map result=jsonDecode(res.body);
      List finalData=[Info.fromMap(result['info'])],
        data=result['results'];
      for(int i=0;i<data.length;i++){
        Map<String,dynamic> lr=data[i];//localResult
        finalData.add(Character.fromMap(lr));
      }
      return finalData;
    }
  }else return getCharacters(id:id,page:page,ids:ids);
}


Future<List> getLocations({int?id,int?page,List<int>?ids})async{
	var res=await http.get(Uri.parse("$baseUrl/location/${id!=null?"$id":''}${page!=null?"?page=$page":''}${ids!=null?ids:''}"));
  if(res.statusCode==200){
    if(id!=null){
      return [Location.fromMap(jsonDecode(res.body))];
    }else if(ids!=null){
      List<Location>finalData=[];
      for(var i in jsonDecode(res.body)){
        finalData.add(Location.fromMap(i));
      }
      return finalData;
    }else{
      Map result=jsonDecode(res.body);
      List finalData=[Info.fromMap(result['info'])],
        data=result['results'];
      for(int i=0;i<data.length;i++){
        Map<String,dynamic> lr=data[i];//localResult
        finalData.add(Location.fromMap(lr));
      }
      return finalData;
    }
  }else return getCharacters(id:id,page:page,ids:ids);
}

Future<List> getEpisodes({int?id,int?page,List<int>?ids})async{
	var res=await http.get(Uri.parse("$baseUrl/episode/${id!=null?"$id":''}${page!=null?"?page=$page":''}${ids!=null?ids:''}"));
  if(res.statusCode==200){
    if(id!=null){
      return [Episode.fromMap(jsonDecode(res.body))];
    }else if(ids!=null){
      List<Episode>finalData=[];
      for(var i in jsonDecode(res.body)){
        finalData.add(Episode.fromMap(i));
      }
      return finalData;
    }else{
      Map result=jsonDecode(res.body);
      List finalData=[Info.fromMap(result['info'])],
        data=result['results'];
      for(int i=0;i<data.length;i++){
        Map<String,dynamic> lr=data[i];//localResult
        finalData.add(Episode.fromMap(lr));
      }
      return finalData;
    }
  }else return getCharacters(id:id,page:page,ids:ids);
}
