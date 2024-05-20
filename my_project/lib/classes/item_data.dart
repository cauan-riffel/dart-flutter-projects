class ItemData{
  String name;
  String? description;

  double price;
  int available,id;


  ItemData({
    required this.id,
    required this.name,
    required this.available,
    required this.price,

    this.description
  });
}
