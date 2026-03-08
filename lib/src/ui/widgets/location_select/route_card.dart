import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

part 'route_card_header.dart';
part 'confirm_button.dart';
part 'marker_widget.dart';
part 'helpers.dart';
part 'route_point_model.dart';
part 'route_status_chip.dart';
part 'rounded_icon.dart';
part 'segment_row.dart';
part 'segment_picker_sheet.dart';
part 'badge.dart';

// ─────────────────────────────────────────────────────────────────
// RouteCardStack
// ─────────────────────────────────────────────────────────────────

class RouteCardStack extends StatefulWidget {
  final List<RoutePoint> points;
  final int activeIndex;
  final void Function(int) onTapPoint;
  final void Function(int) onRemove;
  final VoidCallback onAddStop;
  final VoidCallback? onConfirmRoute;
  final void Function(List<SegmentTransport?>)? onSegmentsChanged;
  final bool initiallyExpanded;

  /// Controls confirm button visibility. True only when all polylines are ready.
  final bool canConfirm;

  /// Shows a spinner/shimmer in the header while OSRM is fetching.
  final bool isLoadingRoutes;

  const RouteCardStack({
    super.key,
    required this.points,
    required this.activeIndex,
    required this.onTapPoint,
    required this.onRemove,
    required this.onAddStop,
    this.onConfirmRoute,
    this.onSegmentsChanged,
    this.initiallyExpanded = true,
    this.canConfirm = false,
    this.isLoadingRoutes = false,
  });

  @override
  State<RouteCardStack> createState() => _RouteCardStackState();
}

class _RouteCardStackState extends State<RouteCardStack>
    with SingleTickerProviderStateMixin {
  late List<SegmentTransport?> _segments;
  late bool _expanded;

  late final AnimationController _chevronCtrl;
  late final Animation<double> _chevronTurns;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _segments = List.filled((widget.points.length - 1).clamp(0, 99), null);
    _chevronCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: _expanded ? 1.0 : 0.0,
    );
    _chevronTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _chevronCtrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() { _chevronCtrl.dispose(); super.dispose(); }

  @override
  void didUpdateWidget(RouteCardStack old) {
    super.didUpdateWidget(old);
    final needed = (widget.points.length - 1).clamp(0, 99);
    if (_segments.length != needed) {
      final next = List<SegmentTransport?>.filled(needed, null);
      for (var i = 0; i < next.length && i < _segments.length; i++) next[i] = _segments[i];
      _segments = next;
    }
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _chevronCtrl.forward() : _chevronCtrl.reverse();
  }

  bool get _allAddressFilled => widget.points.every((p) => p.address.isNotEmpty);
  int  get _filledCount      => widget.points.where((p) => p.address.isNotEmpty).length;

  List<RoutePoint> get _ordered {
    return [
      ...widget.points.where((p) => p.type == PointType.pickup),
      ...widget.points.where((p) => p.type == PointType.stop),
      ...widget.points.where((p) => p.type == PointType.delivery),
    ];
  }

  int      _originalIndex(int id) => widget.points.indexWhere((p) => p.id == id);
  Color    _dotColor(PointType t) => switch (t) {
    PointType.pickup   => const Color(0xFF4CC9F0),
    PointType.stop     => const Color(0xFFFFD166),
    PointType.delivery => const Color(0xFFFF6B35),
  };
  IconData _dotIcon(PointType t) => switch (t) {
    PointType.pickup   => Symbols.trip_origin,
    PointType.stop     => Symbols.radio_button_checked,
    PointType.delivery => Symbols.location_on,
  };

  void _pickSegment(int segIdx) {
    final ordered = _ordered;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SegmentPickerSheet(
        segmentIndex: segIdx,
        from: ordered[segIdx],
        to: ordered[segIdx + 1],
        current: _segments[segIdx],
        onSelect: (t) {
          setState(() => _segments[segIdx] = t);
          widget.onSegmentsChanged?.call(List.unmodifiable(_segments));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordered   = _ordered;
    final stopCount = widget.points.where((p) => p.type == PointType.stop).length;
    final canAdd    = stopCount < 3;
    int stopCounter  = 0;

    final List<Widget> rows = [];
    for (var i = 0; i < ordered.length; i++) {
      final p        = ordered[i];
      final isActive = _originalIndex(p.id) == widget.activeIndex;
      if (p.type == PointType.stop) stopCounter++;

      final typeLabel = switch (p.type) {
        PointType.pickup   => 'PICKUP',
        PointType.stop     => 'STOP $stopCounter',
        PointType.delivery => 'DELIVERY',
      };

      rows.add(Material(
        color: isActive ? _dotColor(p.type).withOpacity(0.07) : Colors.transparent,
        child: ListTile(
          onTap: () => widget.onTapPoint(_originalIndex(p.id)),
          leading: RoundedIcon(
            icon: _dotIcon(p.type),
            iconColor: _dotColor(p.type),
            borderColor: _dotColor(p.type),
            containerColor: isActive ? _dotColor(p.type).withOpacity(0.07) : Colors.transparent,
            height: 32, width: 32, iconSize: 16,
            shape: BoxShape.circle,
          ),
          title: Row(children: [
            _Badge(label: typeLabel, color: _dotColor(p.type)),
            if (p.type == PointType.delivery) ...[
              const SizedBox(width: 5),
              _Badge(label: 'FINAL', color: const Color(0xFFFF6B35), outlined: true),
            ],
          ]),
          subtitle: Text(
            p.address.isEmpty ? 'Tap to set location' : p.address,
            style: TextStyle(
              color: p.address.isEmpty ? Colors.white30 : Colors.white,
              fontSize: 13, fontWeight: FontWeight.w500,
            ),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          trailing: (p.type == PointType.stop || p.type == PointType.delivery)
              ? IconButton.outlined(
            onPressed: p.type == PointType.delivery ? null : () => widget.onRemove(p.id),
            color: p.type == PointType.delivery ? null : Colors.white.withOpacity(0.06),
            icon: Icon(
              p.type == PointType.delivery ? Symbols.lock : Icons.close_rounded,
              color: p.type == PointType.delivery
                  ? const Color(0xFFFF6B35).withOpacity(0.35)
                  : Colors.white38,
              size: 13,
            ),
          )
              : const SizedBox(),
        ),
      ));

      if (i < ordered.length - 1) {
        rows.add(_SegmentRow(
          segmentIndex: i,
          transport: _segments.length > i ? _segments[i] : null,
          fromColor: _dotColor(ordered[i].type),
          toColor: _dotColor(ordered[i + 1].type),
          onTap: () => _pickSegment(i),
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117).withOpacity(0.93),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 6)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Header ─────────────────────────────────────────
            _RouteCardHeader(
              points: widget.points,
              filledCount: _filledCount,
              allFilled: _allAddressFilled,
              isLoading: widget.isLoadingRoutes,
              canConfirm: widget.canConfirm,
              chevronTurns: _chevronTurns,
              onTap: _toggle,
              dotColor: _dotColor,
            ),

            // ── Body ────────────────────────────────────────────
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeOutCubic,
              secondCurve: Curves.easeInCubic,
              sizeCurve: Curves.easeInOutCubic,
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 1, color: Colors.white.withOpacity(0.06)),
                  ...rows,
                  if (canAdd) ...[
                    Divider(height: 1, color: Colors.white.withOpacity(0.06)),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: widget.onAddStop,
                        leading: const RoundedIcon(),
                        title: const Text(
                          'Add stop before delivery',
                          style: TextStyle(color: Color(0xFFFFD166), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$stopCount/3',
                            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // ── Confirm Route button ─────────────────────
                  // Only appears when canConfirm = true
                  AnimatedSize(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    child: widget.canConfirm && widget.onConfirmRoute != null
                        ? Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: _ConfirmRouteButton(onTap: widget.onConfirmRoute!),
                    )
                        : const SizedBox.shrink(),
                  ),

                  // ── Route building status chip ───────────────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    child: (_allAddressFilled && !widget.canConfirm)
                        ? _RouteStatusChip(isLoading: widget.isLoadingRoutes)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              secondChild: const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
