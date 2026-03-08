class SimpleLoad {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? price;
  final String? endLocation;
  final String? startLocation;
  final String? category;
  final String? finishDate;

  SimpleLoad({
    this.id,
    this.title,
    this.description,
    this.image,
    this.price,
    this.endLocation,
    this.startLocation,
    this.category,
    this.finishDate,
  });

  SimpleLoad copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    String? price,
    String? endLocation,
    String? startLocation,
    String? category,
    String? finishDate,
  }) {
    return SimpleLoad(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      endLocation: endLocation ?? this.endLocation,
      startLocation: startLocation ?? this.startLocation,
      category: category ?? this.category,
      finishDate: finishDate ?? this.finishDate,
    );
  }


  List<SimpleLoad> main() {
    List<SimpleLoad> loads = [];

    SimpleLoad load = SimpleLoad(
      id: '1',
      title: 'Dondurma',
      description: 'Buzlukta Dondurma gidecek',
      image: 'Load',
      price: '100',
      endLocation: 'Mary',
      startLocation: 'Asgabat',
      category: 'Ozel Araba',
      finishDate: '2026-02-28',
    );

    SimpleLoad load2 = SimpleLoad(
      id: '2',
      title: 'Dondurma',
      description: 'Buzlukta Dondurma gidecek',
      image: 'Load',
      price: '100',
      endLocation: 'Mary',
      startLocation: 'Asgabat',
      category: 'Ozel Araba',
      finishDate: '2026-02-28',
    );

    SimpleLoad load3 = SimpleLoad(
      id: '3',
      title: 'Dondurma',
      description: 'Buzlukta Dondurma gidecek',
      image: 'Load',
      price: '100',
      endLocation: 'Mary',
      startLocation: 'Asgabat',
      category: 'Ozel Araba',
      finishDate: '2026-02-28',
    );

    loads.addAll([load, load2, load3]);

    return loads;
  }
}