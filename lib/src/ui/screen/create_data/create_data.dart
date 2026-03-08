import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

const _accent      = Color(0xFF818CF8);
const _cardSurface = Color(0xFF0D1117);
const _darkSurface = Color(0xFF1E293B);
const _inputSurf   = Color(0xFF1B232F);
const _iconCol     = Color(0xFFCBD5E1);

const _truckTypes = [
  'Sedan / Minivan', 'Pickup Truck', 'Box Truck (3–5 t)',
  'Medium Truck (5–10 t)', 'Heavy Truck (10–20 t)',
  'Semi-Trailer (20 t+)', 'Flatbed Trailer', 'Refrigerated Truck',
];
const _loadTypes = [
  'Full Truck Load (FTL)', 'Less Than Load (LTL)',
  'Groupage / Consolidation', "Container 20'", "Container 40'",
  'Flatbed Open Load', 'Oversized / Heavy Lift',
];
const _cargoTypes = [
  'General Cargo', 'Electronics', 'Textiles', 'Food & Beverages',
  'Chemicals', 'Machinery', 'Furniture', 'Raw Materials',
  'Pharmaceuticals', 'Automotive Parts',
];
const _currencies = ['USD', 'EUR', 'TMT', 'RUB', 'IRR', 'TRY'];

// ─────────────────────────────────────────────
class TransportFormScreen extends StatefulWidget {
  const TransportFormScreen({super.key});
  @override
  State<TransportFormScreen> createState() => _TransportFormScreenState();
}

class _TransportFormScreenState extends State<TransportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Required ──
  final _weightCtrl  = TextEditingController();
  final _palletsCtrl = TextEditingController();
  final _priceCtrl   = TextEditingController();
  DateTime? _pickupDate;
  String _currency = 'USD';

  // ── Advanced ──
  final _volumeCtrl    = TextEditingController();
  final _noteCtrl      = TextEditingController();
  final _loadShareCtrl = TextEditingController(); // consolidation %
  bool _flexibleLoad   = false;
  String? _truckType;
  String? _loadType;
  String? _cargoType;
  bool _isFragile         = false;
  bool _isHazardous       = false;
  bool _needsRefrigeration = false;
  bool _needsInsurance    = false;
  bool _customsClearance  = false;

  // Count filled advanced fields for the badge
  int get _advancedFilledCount {
    int n = 0;
    if (_volumeCtrl.text.isNotEmpty) n++;
    if (_loadShareCtrl.text.isNotEmpty) n++;
    if (_noteCtrl.text.isNotEmpty) n++;
    if (_truckType != null) n++;
    if (_loadType != null) n++;
    if (_cargoType != null) n++;
    if (_isFragile) n++;
    if (_isHazardous) n++;
    if (_needsRefrigeration) n++;
    if (_needsInsurance) n++;
    if (_customsClearance) n++;
    return n;
  }

  @override
  void dispose() {
    for (final c in [_weightCtrl, _palletsCtrl, _priceCtrl, _volumeCtrl, _noteCtrl, _loadShareCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _accent, surface: Color(0xFF1C2333),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _pickupDate = picked);
  }

  String get _fmtDate => _pickupDate == null
      ? 'Select date'
      : '${_pickupDate!.day.toString().padLeft(2, '0')}.${_pickupDate!.month.toString().padLeft(2, '0')}.${_pickupDate!.year}';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transport created successfully'),
          backgroundColor: _accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.pop();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardSurface,
      appBar: AppBar(
        backgroundColor: _darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back, color: _iconCol),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Transport',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}), // badge refresh
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          children: [

            // ── Cargo ─────────────────────────────────
            _Section(
              icon: Symbols.inventory_2,
              title: 'Cargo',
              children: [
                Row(children: [
                  Expanded(child: _InputField(
                    label: 'Weight',
                    hint: '0.00',
                    suffix: 'ton',
                    controller: _weightCtrl,
                    inputType: TextInputType.number,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _InputField(
                    label: 'Pallets',
                    hint: '0',
                    suffix: 'pcs',
                    controller: _palletsCtrl,
                    inputType: TextInputType.number,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  )),
                ]),
              ],
            ),

            const SizedBox(height: 14),

            // ── Schedule ──────────────────────────────
            _Section(
              icon: Symbols.calendar_month,
              title: 'Schedule',
              children: [
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    decoration: BoxDecoration(
                      color: _inputSurf,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _pickupDate != null
                            ? _accent.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(children: [
                      Icon(Symbols.calendar_today,
                          color: _pickupDate != null ? _accent : const Color(0xFF475569),
                          size: 16),
                      const SizedBox(width: 10),
                      Text(
                        _fmtDate,
                        style: TextStyle(
                          color: _pickupDate != null ? Colors.white : const Color(0xFF475569),
                          fontSize: 14,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Price ─────────────────────────────────
            _Section(
              icon: Symbols.payments,
              title: 'Price',
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    flex: 3,
                    child: _InputField(
                      label: 'Offer Price',
                      hint: '0.00',
                      controller: _priceCtrl,
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _DropdownField(
                      label: 'Currency',
                      hint: 'USD',
                      value: _currency,
                      items: _currencies,
                      onChanged: (v) => setState(() => _currency = v ?? 'USD'),
                    ),
                  ),
                ]),
              ],
            ),

            const SizedBox(height: 14),

            // ── Advanced (ExpansionTile) ───────────────
            Container(
              decoration: BoxDecoration(
                color: _darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.07)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Symbols.tune, color: _accent, size: 16),
                  ),
                  title: Row(children: [
                    const Text(
                      'Advanced Options',
                      style: TextStyle(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_advancedFilledCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_advancedFilledCount',
                          style: const TextStyle(
                            color: _accent, fontSize: 11, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ]),
                  iconColor: _accent,
                  collapsedIconColor: const Color(0xFF475569),
                  backgroundColor: _darkSurface,
                  collapsedBackgroundColor: _darkSurface,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Divider(color: Colors.white.withOpacity(0.06), height: 1),
                    const SizedBox(height: 16),

                    _DropdownField(
                      label: 'Truck Type',
                      hint: 'Select truck type',
                      value: _truckType,
                      items: _truckTypes,
                      onChanged: (v) => setState(() => _truckType = v),
                    ),
                    const SizedBox(height: 14),
                    _DropdownField(
                      label: 'Load Type',
                      hint: 'Select load type',
                      value: _loadType,
                      items: _loadTypes,
                      onChanged: (v) => setState(() => _loadType = v),
                    ),

                    // ── Consolidation calculator ──────────
                    if (_loadType == 'Less Than Load (LTL)' ||
                        _loadType == 'Groupage / Consolidation') ...[
                      const SizedBox(height: 14),
                      _ConsolidationCard(
                        weightCtrl: _weightCtrl,
                        volumeCtrl: _volumeCtrl,
                        loadShareCtrl: _loadShareCtrl,
                        flexibleLoad: _flexibleLoad,
                        onFlexibleChanged: (v) => setState(() => _flexibleLoad = v),
                      ),
                    ],

                    const SizedBox(height: 14),
                    _DropdownField(
                      label: 'Cargo Type',
                      hint: 'Select cargo type',
                      value: _cargoType,
                      items: _cargoTypes,
                      onChanged: (v) => setState(() => _cargoType = v),
                    ),
                    const SizedBox(height: 14),
                    _InputField(
                      label: 'Volume',
                      hint: '0.00',
                      suffix: 'm³',
                      controller: _volumeCtrl,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),

                    // Toggles
                    _ToggleTile(
                      icon: Symbols.broken_image,
                      label: 'Fragile',
                      value: _isFragile,
                      onChanged: (v) => setState(() => _isFragile = v),
                    ),
                    _ToggleTile(
                      icon: Symbols.warning,
                      label: 'Hazardous Materials',
                      value: _isHazardous,
                      onChanged: (v) => setState(() => _isHazardous = v),
                      iconColor: const Color(0xFFFFD166),
                    ),
                    _ToggleTile(
                      icon: Symbols.ac_unit,
                      label: 'Refrigeration Required',
                      value: _needsRefrigeration,
                      onChanged: (v) => setState(() => _needsRefrigeration = v),
                      iconColor: const Color(0xFF4CC9F0),
                    ),
                    _ToggleTile(
                      icon: Symbols.shield,
                      label: 'Cargo Insurance',
                      value: _needsInsurance,
                      onChanged: (v) => setState(() => _needsInsurance = v),
                      iconColor: const Color(0xFF06D6A0),
                    ),
                    _ToggleTile(
                      icon: Symbols.gavel,
                      label: 'Customs Clearance',
                      value: _customsClearance,
                      onChanged: (v) => setState(() => _customsClearance = v),
                      iconColor: const Color(0xFFEF476F),
                    ),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _noteCtrl,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Special instructions...',
                        hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
                        filled: true,
                        fillColor: _inputSurf,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _accent, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        price: _priceCtrl.text,
        currency: _currency,
        onSubmit: _submit,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Section
// ─────────────────────────────────────────────
class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.children});
  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _accent, size: 16),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ),
          Divider(color: Colors.white.withOpacity(0.06), height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  InputField
// ─────────────────────────────────────────────
class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.suffix,
    this.inputType = TextInputType.text,
    this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? suffix;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Label(label),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputType == TextInputType.number
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
            : null,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: _dec().copyWith(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF475569)),
          suffixText: suffix,
          suffixStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  DropdownField
// ─────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Label(label),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: value,
        validator: validator,
        dropdownColor: const Color(0xFF1C2333),
        style: const TextStyle(color: _iconCol, fontSize: 14),
        isExpanded: true,
        icon: const Icon(Symbols.keyboard_arrow_down, color: Color(0xFF475569), size: 20),
        decoration: _dec(),
        hint: Text(hint, style: const TextStyle(color: Color(0xFF475569), fontSize: 14)),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  ToggleTile (compact – no subtitle)
// ─────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
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
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? _accent.withOpacity(0.08) : _inputSurf,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: value ? _accent.withOpacity(0.35) : Colors.transparent),
        ),
        child: Row(children: [
          Icon(icon, color: iconColor ?? _iconCol, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _accent,
            activeTrackColor: _accent.withOpacity(0.25),
            inactiveThumbColor: const Color(0xFF475569),
            inactiveTrackColor: Colors.white10,
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Helpers
// ─────────────────────────────────────────────
class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: Color(0xFF64748B), fontSize: 11,
          fontWeight: FontWeight.w600, letterSpacing: 0.6));
}

InputDecoration _dec() => InputDecoration(
  filled: true,
  fillColor: _inputSurf,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _accent, width: 1.5)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6), width: 1.2)),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
  errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
);

// ─────────────────────────────────────────────
//  ConsolidationCard
// ─────────────────────────────────────────────
class _ConsolidationCard extends StatelessWidget {
  const _ConsolidationCard({
    required this.weightCtrl,
    required this.volumeCtrl,
    required this.loadShareCtrl,
    required this.flexibleLoad,
    required this.onFlexibleChanged,
  });

  final TextEditingController weightCtrl;
  final TextEditingController volumeCtrl;
  final TextEditingController loadShareCtrl;
  final bool flexibleLoad;
  final void Function(bool) onFlexibleChanged;

  // Chargeable weight = max(actual weight, volumetric weight)
  // Volumetric weight (ton) = CBM × 0.333  (standard road freight)
  double get _chargeableWeight {
    final w = double.tryParse(weightCtrl.text) ?? 0;
    final cbm = double.tryParse(volumeCtrl.text) ?? 0;
    final volW = cbm * 0.333;
    return w > volW ? w : volW;
  }

  double get _share => double.tryParse(loadShareCtrl.text) ?? 0;

  // Estimated truck capacity: 24 ton / 82 m³ (standard euro trailer)
  static const double _truckTon = 24;
  static const double _truckCbm = 82;

  double get _usedTon  => (_share / 100) * _truckTon;
  double get _usedCbm  => (_share / 100) * _truckCbm;

  @override
  Widget build(BuildContext context) {
    final hasShare = _share > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accent.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(children: [
            const Icon(Symbols.merge, color: _accent, size: 16),
            const SizedBox(width: 8),
            const Text('Consolidation',
                style: TextStyle(
                    color: _accent, fontSize: 12, fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('LTL / Groupage',
                  style: TextStyle(
                      color: _accent, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ]),

          const SizedBox(height: 12),

          // Load share input
          _Label('Load Share (% of truck)'),
          const SizedBox(height: 6),
          TextFormField(
            controller: loadShareCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required for consolidation';
              final n = double.tryParse(v);
              if (n == null || n <= 0 || n > 100) return '1 – 100';
              return null;
            },
            decoration: _dec().copyWith(
              hintText: 'e.g. 40',
              hintStyle: const TextStyle(color: Color(0xFF475569)),
              suffixText: '%',
              suffixStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
            ),
          ),

          // Results
          if (hasShare) ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _StatChip(
                label: 'Reserved capacity',
                value: '${_usedTon.toStringAsFixed(1)} ton',
                sub: '${_usedCbm.toStringAsFixed(1)} m³',
              )),
              const SizedBox(width: 8),
              Expanded(child: _StatChip(
                label: 'Chargeable weight',
                value: '${_chargeableWeight.toStringAsFixed(2)} ton',
                sub: 'max(actual, vol.)',
              )),
            ]),
          ],

          // Progress bar
          if (hasShare) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_share / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _share > 80 ? const Color(0xFFEF476F) : _accent,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_share.toStringAsFixed(0)}% of standard trailer (24 t / 82 m³)',
              style: const TextStyle(color: Color(0xFF475569), fontSize: 11),
            ),
          ],

          const SizedBox(height: 10),

          // Flexible toggle
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: flexibleLoad ? _accent.withOpacity(0.08) : _inputSurf,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: flexibleLoad ? _accent.withOpacity(0.3) : Colors.transparent),
            ),
            child: Row(children: [
              const Icon(Symbols.swap_horiz, color: _iconCol, size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Flexible load share',
                    style: TextStyle(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              Switch(
                value: flexibleLoad,
                onChanged: onFlexibleChanged,
                activeColor: _accent,
                activeTrackColor: _accent.withOpacity(0.25),
                inactiveThumbColor: const Color(0xFF475569),
                inactiveTrackColor: Colors.white10,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value, required this.sub});
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _inputSurf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF475569), fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        Text(sub,
            style: const TextStyle(color: Color(0xFF475569), fontSize: 10)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Bottom bar
// ─────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.price, required this.currency, required this.onSubmit});
  final String price;
  final String currency;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: _darkSurface,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text('${price.isEmpty ? '—' : price} $currency',
                  style: const TextStyle(
                      color: _accent, fontSize: 20, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onSubmit,
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
                  Text('Create Transport',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}