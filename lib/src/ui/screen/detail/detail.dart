import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/domain/model/simpleLoad.dart';

const _accent      = Color(0xFF818CF8);
const _cardSurface = Color(0xFF0D1117);
const _darkSurface = Color(0xFF1E293B);
const _iconCol     = Color(0xFFCBD5E1);

class LoadDetailScreen extends StatefulWidget {
  const LoadDetailScreen({super.key, required this.load});
  final SimpleLoad load;

  @override
  State<LoadDetailScreen> createState() => _LoadDetailScreenState();
}

class _LoadDetailScreenState extends State<LoadDetailScreen> {
  bool _isFavorite = false;
  final _scrollController = ScrollController();
  double _headerOpacity = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final opacity = (_scrollController.offset / 180).clamp(0.0, 1.0);
      if ((opacity - _headerOpacity).abs() > 0.01) {
        setState(() => _headerOpacity = opacity);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _cardSurface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ── Hero image ──────────────────────────
              SliverToBoxAdapter(child: _HeroImage(load: widget.load)),

              // ── Content ─────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, bottomPad + 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // Title row
                    _TitleRow(
                      load: widget.load,
                      isFavorite: _isFavorite,
                      onFavoriteTap: () => setState(() => _isFavorite = !_isFavorite),
                    ),

                    const SizedBox(height: 20),

                    // Route card
                    _RouteCard(load: widget.load),

                    const SizedBox(height: 14),

                    // Stats grid
                    _StatsGrid(load: widget.load),

                    const SizedBox(height: 14),

                    // Special flags
                    _FlagsSection(load: widget.load),

                    const SizedBox(height: 14),

                    // Contact / poster
                    _ContactCard(load: widget.load),

                    const SizedBox(height: 14),

                    // Notes
                    if (widget.load.title != null && widget.load.title!.isNotEmpty)
                      _NotesCard(note: widget.load.title!),
                  ]),
                ),
              ),
            ],
          ),

          // ── Bottom action bar ─────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _BottomBar(load: widget.load, bottomPad: bottomPad),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _darkSurface.withOpacity(_headerOpacity),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: _CircleButton(
          icon: Symbols.arrow_back,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          child: _CircleButton(
            icon: Symbols.share,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Hero image with gradient
// ─────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.load});
  final SimpleLoad load;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://picsum.photos/800/400?image=10',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: _darkSurface,
              child: const Center(
                child: Icon(Symbols.local_shipping, color: Color(0xFF334155), size: 56),
              ),
            ),
          ),
          // Bottom fade
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  _cardSurface,
                ],
                stops: const [0.4, 0.7, 1.0],
              ),
            ),
          ),
          // Category + status top-right
          Positioned(
            top: 56,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (load.category != null)
                  _GlassBadge(
                    label: load.category!.toUpperCase(),
                    color: _accent,
                  ),
                const SizedBox(height: 6),
                _GlassBadge(label: 'ACTIVE', color: const Color(0xFF06D6A0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Title + price + favorite
// ─────────────────────────────────────────────
class _TitleRow extends StatelessWidget {
  const _TitleRow({
    required this.load,
    required this.isFavorite,
    required this.onFavoriteTap,
  });
  final SimpleLoad load;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                load.title ?? 'No Title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                load.finishDate ?? '',
                style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${load.price ?? '—'}',
              style: const TextStyle(
                color: _accent,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onFavoriteTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isFavorite
                      ? const Color(0xFFEF476F).withOpacity(0.15)
                      : _darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFavorite
                        ? const Color(0xFFEF476F).withOpacity(0.4)
                        : Colors.white.withOpacity(0.07),
                  ),
                ),
                child: Icon(
                  isFavorite ? Symbols.favorite : Symbols.favorite,
                  color: isFavorite
                      ? const Color(0xFFEF476F)
                      : const Color(0xFF475569),
                  size: 20,
                  fill: isFavorite ? 1 : 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Route card – from → to with dotted line
// ─────────────────────────────────────────────
class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.load});
  final SimpleLoad load;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          // From
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FROM',
                    style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Symbols.trip_origin, color: _accent, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      load.startLocation ?? '—',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ],
            ),
          ),

          // Dotted connector + truck icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              SizedBox(
                width: 60,
                child: CustomPaint(painter: _DotLinePainter()),
              ),
              const SizedBox(height: 4),
              const Icon(Symbols.local_shipping, color: Color(0xFF334155), size: 18),
            ]),
          ),

          // To
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('TO',
                    style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0)),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Flexible(
                    child: Text(
                      load.endLocation ?? '—',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Symbols.location_on,
                      color: Color(0xFFEF476F), size: 16),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Stats 2×2 grid
// ─────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.load});
  final SimpleLoad load;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(icon: Symbols.scale, label: 'Weight',
          value: '120' ?? '—', color: _accent),
      _StatItem(icon: Symbols.view_in_ar, label: 'Volume',
          value: '23' ?? '—', color: const Color(0xFF4CC9F0)),
      _StatItem(icon: Symbols.layers, label: 'Pallets',
          value: 'Automate' ?? '—', color: const Color(0xFF06D6A0)),
      _StatItem(icon: Symbols.local_shipping, label: 'Truck Type',
          value: 'Van' ?? '—', color: const Color(0xFFFFD166)),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: stats.map((s) => _StatTile(item: s)).toList(),
    );
  }
}

class _StatItem {
  const _StatItem(
      {required this.icon,
        required this.label,
        required this.value,
        required this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.item});
  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: item.color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.label,
                  style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4)),
              const SizedBox(height: 2),
              Text(item.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Special flags (fragile, hazardous, etc.)
// ─────────────────────────────────────────────
class _FlagsSection extends StatelessWidget {
  const _FlagsSection({required this.load});
  final SimpleLoad load;

  @override
  Widget build(BuildContext context) {
    final flags = <_FlagItem>[
      // if (load.isFragile == true)
      //   _FlagItem(icon: Symbols.broken_image, label: 'Fragile',
      //       color: const Color(0xFFFFD166)),
      // if (load.isHazardous == true)
      //   _FlagItem(icon: Symbols.warning, label: 'Hazardous',
      //       color: const Color(0xFFEF476F)),
      // if (load.needsRefrigeration == true)
      //   _FlagItem(icon: Symbols.ac_unit, label: 'Refrigerated',
      //       color: const Color(0xFF4CC9F0)),
      // if (load.hasInsurance == true)
      //   _FlagItem(icon: Symbols.shield, label: 'Insured',
      //       color: const Color(0xFF06D6A0)),
      // if (load.customsClearance == true)
      //   _FlagItem(icon: Symbols.gavel, label: 'Customs',
      //       color: _accent),
    ];

    if (flags.isEmpty) return const SizedBox.shrink();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Special Requirements'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: flags.map((f) => _FlagChip(item: f)).toList(),
          ),
        ],
      ),
    );
  }
}

class _FlagItem {
  const _FlagItem({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({required this.item});
  final _FlagItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: item.color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(item.icon, color: item.color, size: 13),
        const SizedBox(width: 5),
        Text(item.label,
            style: TextStyle(
                color: item.color,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Contact card
// ─────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.load});
  final SimpleLoad load;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(children: [
        // Avatar
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.25)),
          ),
          child: const Icon(Symbols.person, color: _accent, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Baymuhammet' ?? 'Unknown',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('+99362043094' ?? '—',
                style: const TextStyle(
                    color: Color(0xFF475569), fontSize: 12)),
          ]),
        ),
        // Call button
        _ActionIconBtn(
          icon: Symbols.call,
          color: const Color(0xFF06D6A0),
          onTap: () {},
        ),
        const SizedBox(width: 8),
        // Message button
        _ActionIconBtn(
          icon: Symbols.chat_bubble,
          color: _accent,
          onTap: () {},
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Notes card
// ─────────────────────────────────────────────
class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Notes'),
          const SizedBox(height: 10),
          Text(note,
              style: const TextStyle(
                  color: _iconCol, fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Bottom action bar
// ─────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.load, required this.bottomPad});
  final SimpleLoad load;
  final double bottomPad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
      decoration: BoxDecoration(
        color: _darkSurface,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(children: [
        // Price recap
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Price',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text('\$${load.price ?? '—'}',
                  style: const TextStyle(
                      color: _accent,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Accept button
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.check_circle, size: 18),
                  SizedBox(width: 8),
                  Text('Accept Load',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Reusable atoms
// ─────────────────────────────────────────────
class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1));
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  const _ActionIconBtn(
      {required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0)),
    );
  }
}

class _DotLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const dashW = 3.0, gap = 4.0;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y),
          Offset((x + dashW).clamp(0, size.width), y), paint);
      x += dashW + gap;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}