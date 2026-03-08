part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// RouteMarkerWidget
// Anchor: Alignment.bottomCenter  |  Size: width 44, height 62
// ─────────────────────────────────────────────────────────────────

class RouteMarkerWidget extends StatelessWidget {
  final RoutePoint point;
  final int orderIndex;
  final Color color;

  const RouteMarkerWidget({
    super.key,
    required this.point,
    required this.orderIndex,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MarkerBubble(point: point, orderIndex: orderIndex, color: color),
        CustomPaint(size: const Size(2, 10), painter: _StemPainter(color: color)),
        Container(
          width: 5, height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color.withOpacity(0.9), blurRadius: 8, spreadRadius: 2)],
          ),
        ),
      ],
    );
  }
}

class _MarkerBubble extends StatelessWidget {
  final RoutePoint point;
  final int orderIndex;
  final Color color;
  const _MarkerBubble({required this.point, required this.orderIndex, required this.color});

  IconData get _icon => switch (point.type) {
    PointType.pickup   => Symbols.trip_origin,
    PointType.stop     => Symbols.radio_button_checked,
    PointType.delivery => Symbols.location_on,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0D1117),
        border: Border.all(color: color, width: 2.2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.5), blurRadius: 14, spreadRadius: 1, offset: const Offset(0, 2)),
          BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: point.type == PointType.stop
            ? Text(
          '$orderIndex',
          style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800, height: 1),
        )
            : Icon(_icon, color: color, size: 18),
      ),
    );
  }
}

class _StemPainter extends CustomPainter {
  final Color color;
  _StemPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withOpacity(0.2)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_StemPainter old) => old.color != color;
}