class Info{
  static fromMap(Map<String,dynamic> o){
    return Info(o['count'],o['pages'],o['next'],o['prev']);
  }

	int count,pages;
	String? next,prev;
	Info(this.count,this.pages,this.next,this.prev);
}


class Character{
  static fromMap(Map<String,dynamic>o){
    return Character(o['id'],o['name'],o['status'],o['species'],o['type'],o['gender'],Map.from(o['origin']),Map.from(o['location']),o['image'],o['episode'],o['url'],o['created']);
  }

	final int id;
	final String name,status,species,type,gender,image,url;
	final Map<String,String>origin,location;
	final List<dynamic>episode;
	late String created;
	Character(this.id,this.name,this.status,this.species,this.type,this.gender,this.origin,this.location,this.image,this.episode,this.url,String created){
		this.created=created.substring(0,10).split('-').reversed.join('/');
	}
}

class Location{
  static fromMap(Map<String,dynamic>o){
    return Location(o['id'],o['name'],o['type'],o['dimension'],o['residents'],o['url'],o['created']);
  }

	int id;
	late String name,type,dimension,url,created;
	List<dynamic> residents;
	Location(this.id,this.name,this.type,this.dimension,this.residents,this.url,String created){
		this.created=created.substring(0,10).split('-').reversed.join('/');
	}
}

class Episode{
  static fromMap(o){
    var t=Episode(o['id'], o['name'], o['air_date'], o['episode'], o['characters'], o['url'], o['created']);
    return t;
  }

  int id;
  String name,airDate,episode,url,created='';
  List characters;
  late String ep,season;

  Episode(this.id,this.name,this.airDate,this.episode,this.characters,this.url,String created){
		this.created=created.substring(0,10).split('-').reversed.join('/');
    ep=episode.substring(1,3);
    season=episode.substring(4,6);
  }
}
