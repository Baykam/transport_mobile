class SimpleLoad2 {
  final String? id;
  final String? origin;
  final String? destination;
  final String? cargo;
  final String? status;
  final String? mode;
  final double? price;
  final String? date;

  SimpleLoad2({
    this.id,
    this.origin,
    this.destination,
    this.cargo,
    this.status,
    this.mode,
    this.price,
    this.date,
  });

  // copyWith handles updating specific fields while keeping others
  SimpleLoad2 copyWith({
    String? id,
    String? origin,
    String? destination,
    String? cargo,
    String? status,
    String? mode,
    double? price,
    String? date,
  }) {
    return SimpleLoad2(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      cargo: cargo ?? this.cargo,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      price: price ?? this.price,
      date: date ?? this.date,
    );
  }


  List<SimpleLoad2> loadList = [
    SimpleLoad2(
      id: '1',
      origin: 'Ashgabat',
      destination: 'Mary',
      cargo: 'Dondurma (Ice Cream)',
      status: 'In Transit',
      mode: 'Refrigerated Truck',
      price: 150.0,
      date: '2026-03-10',
    ),
    SimpleLoad2(
      id: '2',
      origin: 'Balkanabat',
      destination: 'Ashgabat',
      cargo: 'Electronics',
      status: 'Pending',
      mode: 'Van',
      price: 320.50,
      date: '2026-03-12',
    ),
    SimpleLoad2(
      id: '3',
      origin: 'Dashoguz',
      destination: 'Turkmenabat',
      cargo: 'Textiles',
      status: 'Completed',
      mode: 'Truck',
      price: 450.0,
      date: '2026-02-25',
    ),
    // Example of a partial data entry (Nulls allowed)
    // SimpleLoad2(
    //   id: '4',
    //   cargo: 'Furniture',
    //   status: 'Draft',
    //   // price and locations are null here
    // ),
  ];

  List<SimpleLoad2> getTests(){
    List<SimpleLoad2> some = [];
    final one = SimpleLoad2(
    id: '1',
    origin: 'Ashgabat',
    destination: 'Mary',
    cargo: 'Dondurma (Ice Cream)',
    status: 'In Transit',
    mode: 'Refrigerated Truck',
    price: 150.0,
    date: '2026-03-10',
    );
    final tw = SimpleLoad2(
    id: '2',
    origin: 'Balkanabat',
    destination: 'Ashgabat',
    cargo: 'Electronics',
    status: 'Pending',
    mode: 'Van',
    price: 320.50,
    date: '2026-03-12',
    );
    final t = SimpleLoad2(
    id: '3',
    origin: 'Dashoguz',
    destination: 'Turkmenabat',
    cargo: 'Textiles',
    status: 'Completed',
    mode: 'Truck',
    price: 450.0,
    date: '2026-02-25',
    );
    some.addAll([one,tw,t]);
    print(some);
    return some;
  }
}