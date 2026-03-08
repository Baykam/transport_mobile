part of 'route_card.dart';


enum PointType { pickup, stop, delivery }

// ── Transport types ───────────────────────────────────────────────
enum SegmentTransport { truck, airplane, ship, train, van }

extension SegmentTransportExt on SegmentTransport {
  String get label => switch (this) {
    SegmentTransport.truck    => 'Truck',
    SegmentTransport.airplane => 'Air',
    SegmentTransport.ship     => 'Ship',
    SegmentTransport.train    => 'Train',
    SegmentTransport.van      => 'Van',
  };
  IconData get icon => switch (this) {
    SegmentTransport.truck    => Symbols.local_shipping,
    SegmentTransport.airplane => Symbols.flight,
    SegmentTransport.ship     => Symbols.directions_boat,
    SegmentTransport.train    => Symbols.train,
    SegmentTransport.van      => Symbols.airport_shuttle,
  };
  Color get color => switch (this) {
    SegmentTransport.truck    => const Color(0xFFFF6B35),
    SegmentTransport.airplane => const Color(0xFF4CC9F0),
    SegmentTransport.ship     => const Color(0xFF06D6A0),
    SegmentTransport.train    => const Color(0xFFFFD166),
    SegmentTransport.van      => const Color(0xFFBB86FC),
  };
}
