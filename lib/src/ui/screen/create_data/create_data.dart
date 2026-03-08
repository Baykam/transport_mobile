import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateDataScreen extends StatefulWidget {
  const CreateDataScreen({super.key});

  @override
  State<CreateDataScreen> createState() => _CreateDataScreenState();
}

class _CreateDataScreenState extends State<CreateDataScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Form fields
  String? _fromCity;
  String? _toCity;
  String? _cargoType;
  String? _transportType;
  String? _currency = 'USD';
  String? _paymentTerm;
  final _weightCtrl = TextEditingController();
  final _cbmCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _piecesCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime? _loadingDate;
  DateTime? _deliveryDate;
  bool _isFragile = false;
  bool _isHazardous = false;
  bool _needsRefrigeration = false;

  static const _cities = [
    'Ashgabat', 'Tehran', 'Istanbul', 'Dubai', 'Moscow',
    'Almaty', 'Tashkent', 'Baku', 'Ankara', 'Mashhad',
  ];
  static const _cargoTypes = [
    'General Cargo', 'Electronics', 'Textiles', 'Food & Beverages',
    'Chemicals', 'Machinery', 'Furniture', 'Raw Materials', 'Pharmaceuticals',
  ];
  static const _transportTypes = [
    'Full Truck Load (FTL)', 'Less Than Load (LTL)',
    'Flatbed', 'Refrigerated', 'Container 20\'', 'Container 40\'',
  ];
  static const _paymentTerms = [
    'Prepaid', 'Cash on Delivery', 'Net 15', 'Net 30', 'Letter of Credit',
  ];
  static const _currencies = ['USD', 'EUR', 'TMT', 'RUB', 'IRR', 'TRY'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _weightCtrl.dispose();
    _cbmCtrl.dispose();
    _priceCtrl.dispose();
    _piecesCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isLoading) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF6B35),
            surface: Color(0xFF1C2333),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isLoading ? _loadingDate = picked : _deliveryDate = picked);
    }
  }

  String _formatDate(DateTime? d) =>
      d == null ? 'Select Date' : '${d.day.toString().padLeft(2,'0')}.${d.month.toString().padLeft(2,'0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildRouteSection(),
                  const SizedBox(height: 16),
                  _buildCargoSection(),
                  const SizedBox(height: 16),
                  _buildDimensionsSection(),
                  const SizedBox(height: 16),
                  _buildPricingSection(),
                  const SizedBox(height: 16),
                  _buildScheduleSection(),
                  const SizedBox(height: 16),
                  _buildFlagsSection(),
                  const SizedBox(height: 16),
                  _buildNotesSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: const Color(0xFF0D1117),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_alt_rounded, size: 16),
            label: const Text('Draft'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF6B35),
              side: const BorderSide(color: Color(0xFFFF6B35), width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Shipment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Ashgabat → Iran',
              style: TextStyle(
                color: const Color(0xFFFF6B35).withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF1A2035), Color(0xFF0D1117)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Color? accent,
  }) {
    final color = accent ?? const Color(0xFFFF6B35);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141B2D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.06), height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection() {
    return _buildSection(
      title: 'Route',
      icon: Icons.route_rounded,
      accent: const Color(0xFF4CC9F0),
      children: [
        Row(
          children: [
            Expanded(child: _buildDropdown(
              label: 'From',
              value: _fromCity,
              icon: Icons.flight_takeoff_rounded,
              items: _cities,
              onChanged: (v) => setState(() => _fromCity = v),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Color(0xFFFF6B35), size: 16),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildDropdown(
              label: 'To',
              value: _toCity,
              icon: Icons.flight_land_rounded,
              items: _cities,
              onChanged: (v) => setState(() => _toCity = v),
            )),
          ],
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          label: 'Transport Type',
          value: _transportType,
          icon: Icons.local_shipping_rounded,
          items: _transportTypes,
          onChanged: (v) => setState(() => _transportType = v),
        ),
      ],
    );
  }

  Widget _buildCargoSection() {
    return _buildSection(
      title: 'Cargo Details',
      icon: Icons.inventory_2_rounded,
      accent: const Color(0xFF7B61FF),
      children: [
        _buildDropdown(
          label: 'Cargo Type',
          value: _cargoType,
          icon: Icons.category_rounded,
          items: _cargoTypes,
          onChanged: (v) => setState(() => _cargoType = v),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField(
              label: 'Weight (kg)',
              controller: _weightCtrl,
              icon: Icons.scale_rounded,
              hint: '0.00',
              inputType: TextInputType.number,
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(
              label: 'CBM (m³)',
              controller: _cbmCtrl,
              icon: Icons.view_in_ar_rounded,
              hint: '0.00',
              inputType: TextInputType.number,
            )),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Number of Pieces / Pallets',
          controller: _piecesCtrl,
          icon: Icons.layers_rounded,
          hint: '0',
          inputType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildDimensionsSection() {
    return _buildSection(
      title: 'Dimensions (cm)',
      icon: Icons.straighten_rounded,
      accent: const Color(0xFF06D6A0),
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField(
              label: 'Length',
              controller: _lengthCtrl,
              icon: Icons.height_rounded,
              hint: '0',
              inputType: TextInputType.number,
            )),
            const SizedBox(width: 10),
            Expanded(child: _buildTextField(
              label: 'Width',
              controller: _widthCtrl,
              icon: Icons.width_normal_rounded,
              hint: '0',
              inputType: TextInputType.number,
            )),
            const SizedBox(width: 10),
            Expanded(child: _buildTextField(
              label: 'Height',
              controller: _heightCtrl,
              icon: Icons.vertical_align_top_rounded,
              hint: '0',
              inputType: TextInputType.number,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return _buildSection(
      title: 'Pricing',
      icon: Icons.payments_rounded,
      accent: const Color(0xFFFFD166),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: _buildTextField(
                label: 'Total Price',
                controller: _priceCtrl,
                icon: Icons.attach_money_rounded,
                hint: '0.00',
                inputType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildDropdown(
                label: 'Currency',
                value: _currency,
                icon: Icons.currency_exchange_rounded,
                items: _currencies,
                onChanged: (v) => setState(() => _currency = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          label: 'Payment Terms',
          value: _paymentTerm,
          icon: Icons.receipt_long_rounded,
          items: _paymentTerms,
          onChanged: (v) => setState(() => _paymentTerm = v),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return _buildSection(
      title: 'Schedule',
      icon: Icons.calendar_month_rounded,
      accent: const Color(0xFFEF476F),
      children: [
        Row(
          children: [
            Expanded(child: _buildDateTile(
              label: 'Loading Date',
              date: _loadingDate,
              onTap: () => _pickDate(true),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildDateTile(
              label: 'Delivery Date',
              date: _deliveryDate,
              onTap: () => _pickDate(false),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildFlagsSection() {
    return _buildSection(
      title: 'Special Requirements',
      icon: Icons.flag_rounded,
      accent: const Color(0xFFFF6B35),
      children: [
        _buildToggleTile(
          label: 'Fragile',
          subtitle: 'Handle with extra care',
          icon: Icons.broken_image_outlined,
          value: _isFragile,
          onChanged: (v) => setState(() => _isFragile = v),
        ),
        _buildToggleTile(
          label: 'Hazardous Materials',
          subtitle: 'Requires special documentation',
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFFFD166),
          value: _isHazardous,
          onChanged: (v) => setState(() => _isHazardous = v),
        ),
        _buildToggleTile(
          label: 'Refrigeration Required',
          subtitle: 'Temperature-controlled transport',
          icon: Icons.ac_unit_rounded,
          iconColor: const Color(0xFF4CC9F0),
          value: _needsRefrigeration,
          onChanged: (v) => setState(() => _needsRefrigeration = v),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return _buildSection(
      title: 'Notes',
      icon: Icons.notes_rounded,
      accent: Colors.white54,
      children: [
        TextField(
          controller: _noteCtrl,
          maxLines: 3,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Additional instructions or remarks...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        )),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: const Color(0xFF1C2333),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withOpacity(0.3), size: 20),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFFF6B35), size: 18),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
          hint: Text('Select', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: inputType == TextInputType.number
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFFF6B35), size: 18),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        )),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: date != null
                  ? Border.all(color: const Color(0xFFFF6B35).withOpacity(0.5))
                  : null,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Color(0xFFFF6B35), size: 16),
                const SizedBox(width: 8),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: date != null ? Colors.white : Colors.white.withOpacity(0.3),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool value,
    required void Function(bool) onChanged,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFFFF6B35).withOpacity(0.1)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value
                ? const Color(0xFFFF6B35).withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.white54, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 11)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFFF6B35),
              activeTrackColor: const Color(0xFFFF6B35).withOpacity(0.3),
              inactiveThumbColor: Colors.white30,
              inactiveTrackColor: Colors.white12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141B2D),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Price', style: TextStyle(
                    color: Colors.white.withOpacity(0.4), fontSize: 11)),
                Text(
                  '${_priceCtrl.text.isEmpty ? '0.00' : _priceCtrl.text} ${_currency ?? 'USD'}',
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Post Shipment', style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}