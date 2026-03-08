part of '../select_locations_map.dart';
// ── Palette (uygulama genelinde tutarlı) ──
const Color _accent      = Color(0xFF818CF8); // Soft Indigo
const Color _cardSurface = Color(0xFF0D1117); // En koyu – scaffold
const Color _darkSurface = Color(0xFF1E293B); // Slate – tile arkaplanı
const Color _inputSurf   = Color(0xFF1B232F); // Search bar zemin
const Color _iconCol     = Color(0xFFCBD5E1); // Soft grey-white

// ── Demo verisi ──
const List<_Place> _kPlaces = [
  _Place('Aşgabat şäher häkimlik',         'Aşgabat, Merkez',             Symbols.account_balance),
  _Place('Aşgabat şäher Parahat 3/1',      'Aşgabat, Parahat etraby',     Symbols.apartment),
  _Place('Türkmenbaşy halkara aeroporty',  'Türkmenbaşy şäheri',          Symbols.flight),
  _Place('Aşgabat Olimpiýa stadiony',      'Aşgabat, Köpetdag etraby',    Symbols.stadium),
  _Place('Berkarar söwda merkezi',         'Aşgabat, Bitarap Türkmenistan', Symbols.local_mall),
  _Place('Türkmenistan milli muzeýi',      'Aşgabat, Merkez',             Symbols.museum),
  _Place('Halk Maslahatynyň köşgi',        'Aşgabat, Merkez',             Symbols.domain),
  _Place('Aşgabat demirýol menzili',       'Aşgabat, Demirýol etraby',    Symbols.train),
];

class _Place {
  final String name;
  final String subtitle;
  final IconData icon;
  const _Place(this.name, this.subtitle, this.icon);
}

// ─────────────────────────────────────────────
//  SearchDelegate
// ─────────────────────────────────────────────
class LocationSearchDelegate extends SearchDelegate<String> {
  LocationSearchDelegate()
      : super(
    searchFieldLabel: 'Search location...',
    searchFieldStyle: const TextStyle(
      color: _iconCol,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    keyboardType: TextInputType.streetAddress,
    textInputAction: TextInputAction.search,
  );

  // Son aramalar (demo)
  final List<String> _recent = [
    'Aşgabat şäher häkimlik',
    'Berkarar söwda merkezi',
  ];

  // ── Theme override ──
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: _cardSurface,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: _iconCol),
        actionsIconTheme: IconThemeData(color: _iconCol),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 15),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: _iconCol, fontSize: 15),
      ),
    );
  }

  // ── Leading (geri butonu) ──
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Symbols.arrow_back, color: _iconCol),
      onPressed: () => close(context, ''),
    );
  }

  // ── Actions (temizle) ──
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Symbols.close, color: _iconCol, size: 20),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      const SizedBox(width: 4),
    ];
  }

  // ── Suggestions (yazarken) ──
  @override
  Widget buildSuggestions(BuildContext context) => _buildBody(context);

  // ── Results (Enter'a basıldığında) ──
  @override
  Widget buildResults(BuildContext context) => _buildBody(context);


  Widget _buildBody(BuildContext context) {
    final filtered = query.isEmpty
        ? _kPlaces
        : _kPlaces
        .where((p) =>
    p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.subtitle.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _SearchBody(
      query: query,
      places: filtered,
      recentLabels: query.isEmpty ? List.of(_recent) : [],
      onSelect: (name) => close(context, name),
      onRecentRemove: (label) => _recent.remove(label),
    );
  }
}

// ─────────────────────────────────────────────
//  Body Widget
// ─────────────────────────────────────────────
class _SearchBody extends StatelessWidget {
  const _SearchBody({
    required this.query,
    required this.places,
    required this.recentLabels,
    required this.onSelect,
    required this.onRecentRemove,
  });

  final String query;
  final List<_Place> places;
  final List<String> recentLabels;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRecentRemove;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _cardSurface,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [

          // ── Recent searches ──
          if (recentLabels.isNotEmpty) ...[
            const _SectionHeader('Recent'),
            ...recentLabels.map(
                  (label) => _RecentTile(
                label: label,
                onTap: () => onSelect(label),
                onRemove: () => onRecentRemove(label),
              ),
            ),
            const _SectionDivider(),
          ],

          // ── Place results ──
          if (places.isEmpty)
            _EmptyState(query: query)
          else ...[
            if (query.isEmpty) const _SectionHeader('Suggestions'),
            if (query.isNotEmpty) const _SectionHeader('Results'),
            ...places.map(
                  (p) => _PlaceTile(
                place: p,
                query: query,
                onTap: () => onSelect(p.name),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Sub-widgets
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) => Divider(
    color: Colors.white.withOpacity(0.06),
    height: 1,
    indent: 20,
    endIndent: 20,
  );
}

// ── Aksiyon satırı (current location / pick on map) ──
class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: _accent.withOpacity(0.08),
        highlightColor: _accent.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  color: _iconCol,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Son arama satırı ──
class _RecentTile extends StatelessWidget {
  const _RecentTile({
    required this.label,
    required this.onTap,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const Icon(Symbols.history, color: Color(0xFF475569), size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: _iconCol, fontSize: 14),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Symbols.close, color: Color(0xFF475569), size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Yer satırı (highlight'lı) ──
class _PlaceTile extends StatelessWidget {
  const _PlaceTile({
    required this.place,
    required this.query,
    required this.onTap,
  });

  final _Place place;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: _accent.withOpacity(0.08),
        highlightColor: _accent.withOpacity(0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Icon kutusu ──
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Icon(place.icon, color: _iconCol, size: 20),
              ),
              const SizedBox(width: 14),

              // ── İsim + altyazı ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HighlightedText(
                      text: place.name,
                      query: query,
                      baseStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      highlightStyle: const TextStyle(
                        color: _accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      place.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Ok ──
              const Icon(Symbols.chevron_right, color: Color(0xFF334155), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Boş sonuç durumu ──
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _darkSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: const Icon(Symbols.location_off, color: Color(0xFF334155), size: 34),
          ),
          const SizedBox(height: 20),
          Text(
            'No results for "$query"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _iconCol,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different keyword or check\nthe spelling.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Sorgu kelimesini vurgulayan metin ──
class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.highlightStyle,
  });

  final String text;
  final String query;
  final TextStyle baseStyle;
  final TextStyle highlightStyle;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: baseStyle);

    final lower = text.toLowerCase();
    final qLower = query.toLowerCase();
    final index  = lower.indexOf(qLower);

    if (index < 0) return Text(text, style: baseStyle);

    return RichText(
      text: TextSpan(children: [
        if (index > 0)
          TextSpan(text: text.substring(0, index), style: baseStyle),
        TextSpan(
          text: text.substring(index, index + query.length),
          style: highlightStyle,
        ),
        if (index + query.length < text.length)
          TextSpan(text: text.substring(index + query.length), style: baseStyle),
      ]),
    );
  }
}