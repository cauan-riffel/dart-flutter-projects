class Book{
	String id;
	String title,author,description,url;
	List genres;
	Function? remove,update;

  Map<String,dynamic> toMap(){
    return {
      'bookId':id,
      'name':title,
      'author':author,
      'genres':genres,
      'synopsis':description,
      'url':url
    };
  }

	Book(
		this.title,
		this.author,
		this.genres,
		this.description,
		this.url,
    this.id,
		{
			this.remove,
      this.update
		}
	);
}
