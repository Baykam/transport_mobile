part of '../select_locations_map.dart';

class AppBarMap2 extends StatelessWidget {
  const AppBarMap2({super.key, required this.needSearch, required this.onSearch});

  final bool needSearch;
  final Function() onSearch;
  @override
  Widget build(BuildContext context) {
    // Gözü yormayan "Deep Slate" Renk Paleti
    const Color primaryColor = Color(
        0xFF818CF8); // Soft Indigo (Pastel tonlarda)
    const Color darkSurface = Color(
        0xFF1E293B); // Koyu Slate (Arka plan butonları için)
    const Color inputSurface = Color(0xFF1B232F); // Arama çubuğu için orta ton
    const Color iconColor = Color(0xFFCBD5E1); // Soft Gri/Beyaz ikonlar

    final topPad = MediaQuery
        .of(context)
        .padding
        .top + 12;

    return Positioned(
      top: topPad,
      left: 16,
      right: 16,
      child: Row(
        children: [
          _buildModernMapButton(
            icon: Symbols.chevron_left,
            onTap: () => Navigator.pop(context),
            backgroundColor: darkSurface,
            iconColor: iconColor,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: _buildTapableSearch(inputSurface, iconColor, primaryColor,needSearch? 52 : 0, onSearch),
          ),
          const SizedBox(width: 12),

          _buildModernMapButton(
            icon: Symbols.layers,
            onTap: () {},
            backgroundColor: primaryColor.withOpacity(0.8),
            iconColor: Colors.white,
            useShadow: true,
          ),
        ],
      ),
    );
  }
}


Widget _buildModernMapButton({
  required IconData icon,
  required VoidCallback onTap,
  required Color backgroundColor,
  required Color iconColor,
  bool useShadow = false,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: useShadow
          ? [BoxShadow(color: backgroundColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
          : [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white10,
        highlightColor: Colors.white10,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: iconColor, size: 26),
        ),
      ),
    ),
  );
}

// Tıklanabilir Arama Çubuğu
Widget _buildTapableSearch(Color surface, Color iconCol, Color accent, double height, Function() ontap) {
  return Material(
    color: surface.withOpacity(0.85),
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: ontap, // Arama sayfasına yönlendir
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 320),
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Symbols.search, color: accent, size: 22),
              const SizedBox(width: 12),
              Text(
                'Search Location...',
                style: TextStyle(
                  color: iconCol.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
