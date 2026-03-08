import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ── Palette ──
const _accent      = Color(0xFF818CF8);
const _cardSurface = Color(0xFF0D1117);
const _darkSurface = Color(0xFF1E293B);
const _inputSurf   = Color(0xFF1B232F);
const _iconCol     = Color(0xFFCBD5E1);

// ── Filter model ──────────────────────────────
class LoadFilter {
  const LoadFilter({
    this.categories = const [],
    this.truckTypes = const [],
    this.minPrice,
    this.maxPrice,
    this.minWeight,
    this.maxWeight,
    this.loadingDate,
    this.isFragile = false,
    this.isHazardous = false,
    this.needsRefrigeration = false,
    this.hasInsurance = false,
    this.customsClearance = false,
    this.sortBy = SortBy.newest,
  });

  final List<String> categories;
  final List<String> truckTypes;
  final double? minPrice;
  final double? maxPrice;
  final double? minWeight;
  final double? maxWeight;
  final DateTime? loadingDate;
  final bool isFragile;
  final bool isHazardous;
  final bool needsRefrigeration;
  final bool hasInsurance;
  final bool customsClearance;
  final SortBy sortBy;

  int get activeCount {
    int n = 0;
    if (categories.isNotEmpty) n++;
    if (truckTypes.isNotEmpty) n++;
    if (minPrice != null || maxPrice != null) n++;
    if (minWeight != null || maxWeight != null) n++;
    if (loadingDate != null) n++;
    if (isFragile) n++;
    if (isHazardous) n++;
    if (needsRefrigeration) n++;
    if (hasInsurance) n++;
    if (customsClearance) n++;
    return n;
  }

  LoadFilter copyWith({
    List<String>? categories,
    List<String>? truckTypes,
    double? minPrice,
    double? maxPrice,
    double? minWeight,
    double? maxWeight,
    DateTime? loadingDate,
    bool? isFragile,
    bool? isHazardous,
    bool? needsRefrigeration,
    bool? hasInsurance,
    bool? customsClearance,
    SortBy? sortBy,
    bool clearPrice = false,
    bool clearWeight = false,
    bool clearDate = false,
  }) {
    return LoadFilter(
      categories: categories ?? this.categories,
      truckTypes: truckTypes ?? this.truckTypes,
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      minWeight: clearWeight ? null : (minWeight ?? this.minWeight),
      maxWeight: clearWeight ? null : (maxWeight ?? this.maxWeight),
      loadingDate: clearDate ? null : (loadingDate ?? this.loadingDate),
      isFragile: isFragile ?? this.isFragile,
      isHazardous: isHazardous ?? this.isHazardous,
      needsRefrigeration: needsRefrigeration ?? this.needsRefrigeration,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      customsClearance: customsClearance ?? this.customsClearance,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum SortBy { newest, priceLow, priceHigh, weightLow, weightHigh }

extension SortByExt on SortBy {
  String get label => switch (this) {
    SortBy.newest     => 'Newest',
    SortBy.priceLow   => 'Price ↑',
    SortBy.priceHigh  => 'Price ↓',
    SortBy.weightLow  => 'Weight ↑',
    SortBy.weightHigh => 'Weight ↓',
  };
}

// ── Static data ───────────────────────────────
const _kCategories = [
  'General Cargo', 'Electronics', 'Textiles',
  'Food & Beverages', 'Chemicals', 'Machinery',
  'Furniture', 'Pharmaceuticals', 'Automotive',
];
const _kTruckTypes = [
  'Pickup Truck', 'Box Truck', 'Medium Truck',
  'Semi-Trailer', 'Flatbed', 'Refrigerated', 'Tanker',
];

// ─────────────────────────────────────────────
//  Entry point — show as modal bottom sheet
// ─────────────────────────────────────────────
class FilterLoads extends StatelessWidget {
  const FilterLoads({super.key});

  /// Call this from outside to open the filter sheet.
  static Future<LoadFilter?> show(
      BuildContext context, {
        LoadFilter initial = const LoadFilter(),
      }) {
    return showModalBottomSheet<LoadFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(initial: initial),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardSurface,
      appBar: AppBar(
        backgroundColor: _darkSurface,
        elevation: 0,
        title: const Text('Filter Loads',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back, color: _iconCol),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const _FilterSheet(initial: LoadFilter()),
    );
  }
}

// ─────────────────────────────────────────────
//  Filter sheet (stateful core)
// ─────────────────────────────────────────────
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});
  final LoadFilter initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late LoadFilter _filter;
  RangeValues _priceRange  = const RangeValues(0, 50000);
  RangeValues _weightRange = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    _filter = widget.initial;
    _priceRange  = RangeValues(
      _filter.minPrice  ?? 0,
      _filter.maxPrice  ?? 50000,
    );
    _weightRange = RangeValues(
      _filter.minWeight ?? 0,
      _filter.maxWeight ?? 100,
    );
  }

  void _toggleCategory(String c) {
    final list = List<String>.from(_filter.categories);
    list.contains(c) ? list.remove(c) : list.add(c);
    setState(() => _filter = _filter.copyWith(categories: list));
  }

  void _toggleTruck(String t) {
    final list = List<String>.from(_filter.truckTypes);
    list.contains(t) ? list.remove(t) : list.add(t);
    setState(() => _filter = _filter.copyWith(truckTypes: list));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filter.loadingDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
              primary: _accent, surface: Color(0xFF1C2333)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _filter = _filter.copyWith(loadingDate: picked));
    }
  }

  String _fmtDate(DateTime? d) => d == null
      ? 'Any date'
      : '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final isSheet   = Navigator.canPop(context) &&
        ModalRoute.of(context) is ModalBottomSheetRoute;

    return Container(
      decoration: BoxDecoration(
        color: _cardSurface,
        borderRadius: isSheet
            ? const BorderRadius.vertical(top: Radius.circular(24))
            : null,
      ),
      child: Column(
        mainAxisSize: isSheet ? MainAxisSize.min : MainAxisSize.max,
        children: [
          // ── Drag handle (sheet only) ──
          if (isSheet) ...[
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                const Text('Filter Loads',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                if (_filter.activeCount > 0)
                  TextButton(
                    onPressed: () => setState(() {
                      _filter = const LoadFilter();
                      _priceRange  = const RangeValues(0, 50000);
                      _weightRange = const RangeValues(0, 100);
                    }),
                    child: const Text('Clear all',
                        style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                  ),
              ]),
            ),
            const SizedBox(height: 4),
          ],

          // ── Scrollable body ──
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad + 100),
              children: [

                // ── Sort ────────────────────────────
                _SectionHeader(
                  icon: Symbols.sort,
                  title: 'Sort By',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: SortBy.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final s = SortBy.values[i];
                      final active = _filter.sortBy == s;
                      return _SelectChip(
                        label: s.label,
                        selected: active,
                        onTap: () => setState(
                                () => _filter = _filter.copyWith(sortBy: s)),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ── Category ────────────────────────
                _SectionHeader(
                  icon: Symbols.category,
                  title: 'Cargo Type',
                  count: _filter.categories.length,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _kCategories.map((c) => _SelectChip(
                    label: c,
                    selected: _filter.categories.contains(c),
                    onTap: () => _toggleCategory(c),
                  )).toList(),
                ),

                const SizedBox(height: 20),

                // ── Truck type ──────────────────────
                _SectionHeader(
                  icon: Symbols.local_shipping,
                  title: 'Truck Type',
                  count: _filter.truckTypes.length,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _kTruckTypes.map((t) => _SelectChip(
                    label: t,
                    selected: _filter.truckTypes.contains(t),
                    onTap: () => _toggleTruck(t),
                  )).toList(),
                ),

                const SizedBox(height: 20),

                // ── Price range ─────────────────────
                _SectionHeader(
                  icon: Symbols.payments,
                  title: 'Price Range',
                  trailing: _priceRange.start != 0 || _priceRange.end != 50000
                      ? '\$${_priceRange.start.round()} – \$${_priceRange.end.round()}'
                      : null,
                ),
                const SizedBox(height: 4),
                _RangeRow(
                  min: '\$0',
                  max: '\$50K',
                  values: _priceRange,
                  max_: 50000,
                  onChanged: (v) {
                    setState(() {
                      _priceRange = v;
                      _filter = _filter.copyWith(
                          minPrice: v.start, maxPrice: v.end);
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ── Weight range ────────────────────
                _SectionHeader(
                  icon: Symbols.scale,
                  title: 'Weight (ton)',
                  trailing: _weightRange.start != 0 || _weightRange.end != 100
                      ? '${_weightRange.start.round()} – ${_weightRange.end.round()} t'
                      : null,
                ),
                const SizedBox(height: 4),
                _RangeRow(
                  min: '0 t',
                  max: '100 t',
                  values: _weightRange,
                  max_: 100,
                  onChanged: (v) {
                    setState(() {
                      _weightRange = v;
                      _filter = _filter.copyWith(
                          minWeight: v.start, maxWeight: v.end);
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ── Loading date ────────────────────
                _SectionHeader(
                  icon: Symbols.calendar_month,
                  title: 'Loading Date',
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: _darkSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _filter.loadingDate != null
                            ? _accent.withOpacity(0.4)
                            : Colors.white.withOpacity(0.07),
                      ),
                    ),
                    child: Row(children: [
                      Icon(Symbols.calendar_today,
                          color: _filter.loadingDate != null
                              ? _accent
                              : const Color(0xFF475569),
                          size: 16),
                      const SizedBox(width: 10),
                      Text(_fmtDate(_filter.loadingDate),
                          style: TextStyle(
                              color: _filter.loadingDate != null
                                  ? Colors.white
                                  : const Color(0xFF475569),
                              fontSize: 14)),
                      const Spacer(),
                      if (_filter.loadingDate != null)
                        GestureDetector(
                          onTap: () => setState(() =>
                          _filter = _filter.copyWith(clearDate: true)),
                          child: const Icon(Symbols.close,
                              color: Color(0xFF475569), size: 16),
                        ),
                    ]),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Special requirements ────────────
                _SectionHeader(
                  icon: Symbols.flag,
                  title: 'Special Requirements',
                ),
                const SizedBox(height: 10),
                _ToggleRow(
                  icon: Symbols.broken_image,
                  label: 'Fragile',
                  value: _filter.isFragile,
                  onChanged: (v) =>
                      setState(() => _filter = _filter.copyWith(isFragile: v)),
                ),
                _ToggleRow(
                  icon: Symbols.warning,
                  label: 'Hazardous Materials',
                  value: _filter.isHazardous,
                  iconColor: const Color(0xFFFFD166),
                  onChanged: (v) =>
                      setState(() => _filter = _filter.copyWith(isHazardous: v)),
                ),
                _ToggleRow(
                  icon: Symbols.ac_unit,
                  label: 'Refrigeration Required',
                  value: _filter.needsRefrigeration,
                  iconColor: const Color(0xFF4CC9F0),
                  onChanged: (v) => setState(() =>
                  _filter = _filter.copyWith(needsRefrigeration: v)),
                ),
                _ToggleRow(
                  icon: Symbols.shield,
                  label: 'Cargo Insurance',
                  value: _filter.hasInsurance,
                  iconColor: const Color(0xFF06D6A0),
                  onChanged: (v) =>
                      setState(() => _filter = _filter.copyWith(hasInsurance: v)),
                ),
                _ToggleRow(
                  icon: Symbols.gavel,
                  label: 'Customs Clearance',
                  value: _filter.customsClearance,
                  iconColor: const Color(0xFFEF476F),
                  onChanged: (v) => setState(() =>
                  _filter = _filter.copyWith(customsClearance: v)),
                ),
              ],
            ),
          ),

          // ── Bottom action bar ──────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
            decoration: BoxDecoration(
              color: _darkSurface,
              border:
              Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
            ),
            child: Row(children: [
              // Active filter count badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: _filter.activeCount > 0
                      ? _accent.withOpacity(0.12)
                      : _inputSurf,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _filter.activeCount > 0
                        ? _accent.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  _filter.activeCount > 0
                      ? '${_filter.activeCount} active'
                      : 'No filters',
                  style: TextStyle(
                    color: _filter.activeCount > 0
                        ? _accent
                        : const Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _filter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Symbols.check_circle, size: 18),
                        SizedBox(width: 8),
                        Text('Apply Filters',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Section header
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.count,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final int? count;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _accent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, color: _accent, size: 14),
      ),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              color: _iconCol, fontSize: 13, fontWeight: FontWeight.w600)),
      if (count != null && count! > 0) ...[
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('$count',
              style: const TextStyle(
                  color: _accent, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ],
      if (trailing != null) ...[
        const Spacer(),
        Text(trailing!,
            style: const TextStyle(color: _accent, fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    ]);
  }
}

// ─────────────────────────────────────────────
//  Selectable chip
// ─────────────────────────────────────────────
class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _accent.withOpacity(0.15) : _darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _accent.withOpacity(0.5) : Colors.white.withOpacity(0.07),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _accent : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Range slider row
// ─────────────────────────────────────────────
class _RangeRow extends StatelessWidget {
  const _RangeRow({
    required this.min,
    required this.max,
    required this.values,
    required this.max_,
    required this.onChanged,
  });
  final String min;
  final String max;
  final RangeValues values;
  final double max_;
  final void Function(RangeValues) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: _accent,
          inactiveTrackColor: Colors.white.withOpacity(0.08),
          thumbColor: _accent,
          overlayColor: _accent.withOpacity(0.12),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          trackHeight: 3,
          rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 7),
        ),
        child: RangeSlider(
          values: values,
          min: 0,
          max: max_,
          onChanged: onChanged,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(min,
                style: const TextStyle(
                    color: Color(0xFF475569), fontSize: 11)),
            Text(max,
                style: const TextStyle(
                    color: Color(0xFF475569), fontSize: 11)),
          ],
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  Toggle row
// ─────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });
  final IconData icon;
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? _accent.withOpacity(0.07) : _darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? _accent.withOpacity(0.3)
                : Colors.white.withOpacity(0.07),
          ),
        ),
        child: Row(children: [
          Icon(icon, color: iconColor ?? _iconCol, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _accent,
            activeTrackColor: _accent.withOpacity(0.25),
            inactiveThumbColor: const Color(0xFF475569),
            inactiveTrackColor: Colors.white10,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ]),
      ),
    );
  }
}